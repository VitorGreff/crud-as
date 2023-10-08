.section .data
    msgAbertura:    .asciz  "Controle de cadastro de imóveis para locação\n"
    menu:           .asciz  "\nSelecione uma das opções: \n[1] Inserir um registro\n[2] Consultar um registro\n[3] Remover um registro\n[4] Mostrar relatório\n[5] Gravar registro novo\n[6] Recuperar registro\n[7] Sair\n"
    opInvalida:     .asciz  "\nSelecione uma opção válida: \n"


    msgNome:        .asciz  "\nDigite o nome completo: " #32 bytes
    msgCelular:     .asciz  "\nDigite o telefone celular [apenas números]: " #16bytes
    msgTipoImovel:  .asciz  "\nEscolha o tipo de imóvel [casa/apartamento]: " #12 bytes
    msgEndereco:    .asciz  "\nInforme o endereço: " #64 bytes
    msgCidade:      .asciz  "\nCidade: " #32 
    msgBairro:      .asciz  "\nBairro: " #32
    msgNQuartos:    .asciz  "\nInforme o número de quartos simples: " #4bytes
    msgNSuites:     .asciz  "\nInforme o número de suítes: " #4bytes
    msgGaragem:     .asciz  "\nTem garagem? [S/N]: " #4bytes
    msgMetragem:    .asciz  "\nQual a metragem total? " #4bytes
    msgAluguel:     .asciz  "\nQual o valor do aluguel? " #4bytes


    tamNome:   .int 32
    tamCelular: .int 16
    tamTipoImovel:  .int 12
    tamCidade:    .int 32
    tamBairro:     .int 32
    tamQuartos: .int 4
    tamGaragem: .int 4
    tamMetragem: .int 4
    tamAluguel: .int 4

    tipoNum: 			.asciz 	"%d"
	imprimeTipoNum: 	.asciz 	"%d\n"
	Char:			    .asciz	"%c"
	Str:			    .asciz	"%s"
	# pulaLinha: 			.asciz 	"\n"

    op:              .int   0
    removeReg:       .int   0
    limpaScan:       .space 10

    tamReg:          .int   208
    # tamRegArq:       .int   208
    tamList:         .int   0

	head:			        .space  4	# cabeça da lista
	inicioReg:			    .space	4	# campo inicial do registro que está sendo inserido no momento
	regConsultaAtual:	    .space  4 	# registro que está sendo consultado
	pai:					.space	4	# registro antecessor 
	filho:					.space	4	# registro sucessor
	enderecoRemove:			.space 	4	# endereço do registro para remover
    tail:   			    .space 	4	# último endereço do registro

    reg:                .space 208
    descritor:			.int 	0
	NULL:				.int 	0
	numComodos:			.int 	0
	posicaoAtual: 		.int	0	
	iteracao:			.int	0	# número da iteração atual, será usada na remoção
	nomeArq:			.asciz	"registros.txt"
	comodosParaConsultar: .int	0
	totalComodos:		.int	0

    SYS_EXIT: 	.int 1
	SYS_FORK: 	.int 2
	SYS_READ: 	.int 3
	SYS_WRITE: 	.int 4
	SYS_OPEN: 	.int 5
	SYS_CLOSE: 	.int 6
	SYS_CREAT: 	.int 8

	# Constantes de configuração do parametro flag da chamada open()
	O_RDONLY: .int 0x0000 # somente leitura
	O_WRONLY: .int 0x0001 # somente escrita
	O_RDWR:   .int 0x0002 # leitura e escrita
	O_CREAT:  .int 0x0040 # cria o arquivo na abertura, caso ele não exista
	O_EXCL:   .int 0x0080 # força a criação
	O_APPEND: .int 0x0400 # posiciona o cursor do arquivo no final, para adição
	O_TRUNC:  .int 0x0200 # reseta o arquivo aberto, deixando com tamanho 0 (zero)

	S_IRWXU: .int 0x01C0# user (file owner) has read, write and execute permission
	S_IRUSR: .int 0x0100 # user has read permission
	S_IWUSR: .int 0x0080 # user has write permission
	S_IXUSR: .int 0x0040 # user has execute permission
	S_IRWXG: .int 0x0038 # group has read, write and execute permission
	S_IRGRP: .int 0x0020 # group has read permission
	S_IWGRP: .int 0x0010 # group has write permission
	S_IXGRP: .int 0x0008 # group has execute permission
	S_IRWXO: .int 0x0007 # others have read, write and execute permission
	S_IROTH: .int 0x0004 # others have read permission
	S_IWOTH: .int 0x0002 # others have write permission
	S_IXOTH: .int 0x0001 # others have execute permission
	S_NADA:  .int 0x0000 # não altera a situação


.section    .text
.globl      _start
_start:
    pushl   $msgAbertura
    call    printf
    addl    $4, %esp
	# call	recuperaReg
	call	menuOpcoes

_fim:
	pushl $0
	call exit

menuOpcoes:
    pushl   $menu
    call    printf
    pushl   $op
    pushl   $tipoNum
    call    scanf

    addl    $12, %esp

    #insert
    cmpl    $1, op
    je      _insereReg

    #consult
    cmpl    $2, op
    je      _consultaReg

    #delete
    cmpl    $3, op
    je      _removeReg

    #list
    cmpl    $4, op
    je      _listaRegs

    #record
    cmpl    $5, op
    je      _salvaReg

    #retrieve
    cmpl    $6, op
    je      _recuperaReg

    #end
    cmpl    $7, op
    je      _fim

    pushl   $opInvalida
    call    printf
    addl    $4, %esp
    jmp     menuOpcoes

    RET

    _insereReg:
        call limpaScanf
        call leReg
        jmp  menuOpcoes
    _consultaReg:   
        RET
    _removeReg:
        RET
    _listaRegs:
        RET
    _salvaReg:
        RET
    _recuperaReg:
        RET

leReg:
    pushl	tamReg
    call	malloc
    movl	%eax, inicioReg
    movl	inicioReg, %edi
    addl	$4, %esp 

	# NOME

    pushl	$msgNome
    call	printf
    addl	$4, %esp 

    pushl	stdin
    pushl	$32
    pushl	%edi
    call	fgets

    popl	%edi
    addl	$8, %esp 
    addl	$32, %edi 

    # CELULAR

    pushl	%edi

    pushl	$msgCelular
    call	printf
    addl	$4, %esp 
    popl 	%edi
    
    pushl	stdin
    pushl	$16
    pushl	%edi
    call	fgets

    popl	%edi
    addl 	$8, %esp
    addl 	$16, %edi 

    # TIPO DE IMÓVEL (CASA OU APARTAMENTO)

    pushl %edi

    pushl	$msgTipoImovel
    call	printf
    addl	$4, %esp
    popl    %edi

    pushl	stdin
    pushl	$12
    pushl	%edi
    call	fgets

    popl	%edi
    addl 	$8, %esp
    addl 	$12, %edi 

    # ENDEREÇO
    pushl %edi

    pushl	$msgEndereco
    call	printf
    addl	$4, %esp 
    popl 	%edi

    # CIDADE 
    pushl	%edi
    pushl	$msgCidade
    call	printf
    addl	$4, %esp
    popl 	%edi

        
    pushl	stdin
    pushl	$32
    pushl	%edi
    call	fgets

    popl	%edi
    addl 	$8, %esp
    addl	$32, %edi

    # BAIRRO

    pushl	%edi

    pushl	$msgBairro
    call	printf
    addl	$4, %esp 
    popl 	%edi

    pushl	stdin
    pushl	$32
    pushl	%edi
    call	fgets

    popl	%edi
    addl	$8, %esp
    addl	$32, %edi

    # NÚMERO DE QUARTOS

    pushl	%edi
    
    pushl	$msgNQuartos
    call	printf
    addl	$4, %esp

    pushl	$tipoNum
    call	scanf

    addl	$4, %esp
    popl	%edi
    movl	(%edi),%eax
    movl	%eax, numComodos

    addl	$4, %edi

    pushl	stdin
    pushl	$20
    pushl	$limpaScan
    call	fgets
    addl	$12, %esp

    # SUITES
    pushl	%edi
    
    pushl	$msgNSuites
    call	printf
    addl	$4, %esp 

    pushl	$tipoNum
    call	scanf
    addl	$4, %esp

    popl	%edi

    movl	(%edi),%eax
    addl	%eax, numComodos
    addl	$4, %edi 

    pushl	stdin
    pushl	$20
    pushl	$limpaScan
    call	fgets
    addl	$12, %esp 

    # GERAGEM

    pushl	%edi

    pushl	$msgGaragem
    call	printf
    addl	$4, %esp 
    popl 	%edi

    pushl	stdin
    pushl	$4
    pushl	%edi
    call	fgets

    popl	%edi
    addl	$8, %esp 
    addl	$4, %edi 

    # METRAGEM

    pushl	%edi

    pushl	$msgMetragem
    call	printf
    addl	$4, %esp 

    pushl	$tipoNum
    call	scanf

    addl   	$4,%esp
    popl	%edi
    addl	$4, %edi 

    pushl	$limpaScan
    pushl   $Char
    call 	scanf
    addl    $8, %esp 

    # ALUGUEL

    pushl   %edi

    pushl   $msgAluguel
    call    printf
    addl    $4, %esp

    pushl   $tipoNum
    call    scanf
    addl	$4, %esp 

	popl 	%edi
    addl    $4, %edi

    pushl	$limpaScan
    pushl   $Char
    call 	scanf
    addl    $8, %esp 

	# FIM DO REGISTRO, COLOCA 0 NO FINAL
    movl 	$NULL, %eax
    movl   	%eax, (%edi)

    RET

limpaScanf:
	# LIMPA BUFFER DE LEITURA DAS FUNÇÕES SCANF E FGETS	

	pushl	$limpaScan
	pushl   $Char
	call 	scanf
	addl    $8, %esp 
	RET
