.section .data
    msgAbertura:            .asciz  "Controle de cadastro de imóveis para locação\n"
    menu:                   .asciz  "\nSelecione uma das opções: \n[1] Inserir um registro\n[2] Consultar um registro\n[3] Remover um registro\n[4] Mostrar relatório\n[5] Gravar registro novo\n[6] Recuperar registro\n[7] Sair\n"
    opInvalida:             .asciz  "\nSelecione uma opção válida: \n"


    msgNome:                .asciz  "\nDigite o nome completo: " #32 bytes
    msgCelular:             .asciz  "\nDigite o telefone celular [apenas números]: " #16bytes
    msgTipoImovel:          .asciz  "\nEscolha o tipo de imóvel [casa/apartamento]: " #16 bytes
    msgEndereco:            .asciz  "\nInforme o endereço: " #64 bytes
    msgCidade:              .asciz  "\nCidade: " #32 
    msgBairro:              .asciz  "\nBairro: " #32
    msgNQuartos:            .asciz  "\nInforme o número de quartos simples: " #4bytes
    msgNSuites:             .asciz  "\nInforme o número de suítes: " #4bytes
    msgGaragem:             .asciz  "\nTem garagem? [S/N]: " #4bytes
    msgMetragem:            .asciz  "\nQual a metragem total? " #4bytes
    msgAluguel:             .asciz  "\nQual o valor do aluguel? " #4bytes
    
    msgSemRegs:             .asciz  "\nNão há registros\n"
    msgPedeReg:             .asciz  "\nDigite um número de quartos para consulta: "

    msgNumReg:              .asciz  "\nRegistro: %d"
    mostraNome:             .asciz  "\nNome:    %s"
    mostraCelular:          .asciz  "\nCelular: %d"
    mostraTipoImovel:       .asciz  "\nTipo do Imóvel: %s"
    mostraEndereco:         .asciz  "\nEndereco: "
    mostraCidade:           .asciz  "\nCidade:  %s"
    mostraBairro:           .asciz  "\nBairro:  %s"
    mostraNQuartos:         .asciz  "\nQuartos: %d"
    mostraNSuites:          .asciz  "\nSuites:  %d"
    mostraGaragem:          .asciz  "\nGaragem? %c"
    mostraMetragem:         .asciz  "\nMetragem Total: %d"
    mostraAluguel:          .asciz  "\nValor do aluguel: %d"
    mostraNTotal:           .asciz  "\nTotal de quartos e suítes: %d"


    tamNome:                .int 32
    tamCelular:             .int 16
    tamTipoImovel:          .int 16
    tamCidade:              .int 32
    tamBairro:              .int 32
    tamQuartos:             .int 4
    # De novo 4 bytes aqui
    tamGaragem:             .int 4
    tamMetragem:            .int 4
    tamAluguel:             .int 4

    tamReg:                 .int   216
    # tamRegArq:              .int   216

    bytesAteQuartos:         .int 208
    bytesAteProximo:          .int 212

    tipoNum: 			    .asciz 	"%d"
	imprimeTipoNum: 	    .asciz 	"%d\n"
	Char:			        .asciz	"%c"
	Str:			        .asciz	"%s"
	# pulaLinha: 		    	.asciz 	"\n"

    op:                     .int   0
    removeReg:              .int   0
    limpaScan:              .space 10
    tamList:                .int   0

	head:			        .space  4	# cabeça da lista
	inicioReg:			    .space	4	# campo inicial do registro que está sendo inserido no momento
	regAtual:       	    .space  4 	# registro que está sendo consultado
	pai:					.space	4	# registro antecessor 
	filho:					.space	4	# registro sucessor
	enderecoRemove:			.space 	4	# endereço do registro para remover
    tail:   			    .space 	4	# último endereço do registro

    reg:                    .space 216
    descritor:			    .int 	0
	totalQuartos:			.int 	0
	posicaoAtual: 		    .int	0	
	iteracao:			    .int	0	# número da iteração atual, será usada na remoção
	nomeArq:			    .asciz	"registros.txt"
	nQuartosConsulta:       .int	0

    SYS_EXIT: 	            .int 1
	SYS_FORK: 	            .int 2
	SYS_READ: 	            .int 3
	SYS_WRITE: 	            .int 4
	SYS_OPEN: 	            .int 5
	SYS_CLOSE: 	            .int 6
	SYS_CREAT: 	            .int 8

	# Constantes de configuração do parametro flag da chamada open()
	O_RDONLY:               .int 0x0000 # somente leitura
	O_WRONLY:               .int 0x0001 # somente escrita
	O_RDWR:                 .int 0x0002 # leitura e escrita
	O_CREAT:                .int 0x0040 # cria o arquivo na abertura, caso ele não exista
	O_EXCL:                 .int 0x0080 # força a criação
	O_APPEND:               .int 0x0400 # posiciona o cursor do arquivo no final, para adição
	O_TRUNC:                .int 0x0200 # reseta o arquivo aberto, deixando com tamanho 0 (zero)

	S_IRWXU:                .int 0x01C0# user (file owner) has read, write and execute permission
	S_IRUSR:                .int 0x0100 # user has read permission
	S_IWUSR:                .int 0x0080 # user has write permission
	S_IXUSR:                .int 0x0040 # user has execute permission
	S_IRWXG:                .int 0x0038 # group has read, write and execute permission
	S_IRGRP:                .int 0x0020 # group has read permission
	S_IWGRP:                .int 0x0010 # group has write permission
	S_IXGRP:                .int 0x0008 # group has execute permission
	S_IRWXO:                .int 0x0007 # others have read, write and execute permission
	S_IROTH:                .int 0x0004 # others have read permission
	S_IWOTH:                .int 0x0002 # others have write permission
	S_IXOTH:                .int 0x0001 # others have execute permission
	S_NADA:                 .int 0x0000 # não altera a situação


.section    .text
.globl      _start
_start:
    pushl   $msgAbertura
    call    printf
    addl    $4, %esp
	# call	recuperaReg
	call	menuOpcoes

_fim:
	pushl   $0
	call    exit

menuOpcoes:
    pushl   $menu
    call    printf
    pushl   $op
    pushl   $tipoNum
    call    scanf

    addl    $12, %esp

    # INSERIR
    cmpl    $1, op
    je      _insereReg

    # CONSULTA
    cmpl    $2, op
    je      _consultaReg

    # REMOVER
    cmpl    $3, op
    je      _removeReg

    # RELATORIO
    cmpl    $4, op
    je      _mostraRelatorio

    # GRAVAR
    cmpl    $5, op
    je      _salvaReg

    # RECUPERAR
    cmpl    $6, op
    je      _recuperaReg

    # FINALIZAÇÃO
    cmpl    $7, op
    je      _fim

    pushl   $opInvalida
    call    printf
    addl    $4, %esp
    jmp     menuOpcoes

    RET

    _insereReg:
        call    limpaScanf
        call    leReg
        jmp     menuOpcoes
    _consultaReg:   
        call    limpaScanf
        call    consulta
        jmp     menuOpcoes
    _removeReg:
        RET
    _mostraRelatorio:
        call    limpaScanf
        call    relatorio
        jmp     menuOpcoes
    _salvaReg:
        RET
    _recuperaReg:
        RET


insereEOrdena:
    movl    inicioReg, %ecx             # endereço do primeiro registro
    addl    bytesAteQuartos , %ecx       
    
    movl    $0, %ebx
    movl    head, %edi
    cmpl    %edi, %ebx
    je      _inserePrimeiroElemento

    movl    head, %edi
    movl    %edi, pai

    addl    bytesAteQuartos, %edi
    movl    (%edi), %eax
    cmpl    %eax, (%ecx)
    jle     _insereHead

    movl    pai, %edi
    addl    bytesAteProximo, %edi
    cmpl    $0, (%edi)
    je      _insereTail

    movl    pai, %edi
    addl    bytesAteProximo, %edi

    movl    (%edi), %eax
    movl    %eax, filho

    movl    inicioReg, %ecx
    addl    bytesAteQuartos, %ecx

    _loopInsercao:
        movl    pai, %edi
        movl    filho, %ebx

        addl    bytesAteProximo, %edi

        addl    bytesAteQuartos, %ebx
        movl    (%ecx), %eax
        cmpl    (%ebx), %eax
        jle     _insereAntesFilho

        movl    filho, %ebx
        movl    %ebx, pai

        movl    pai, %edi
        addl    bytesAteProximo, %edi
        cmpl    $0, (%edi)
        je      _insereTail

        movl    (%ebx), %eax
        movl    %eax, filho
        jmp     _loopInsercao

    # RET

    _inserePrimeiroElemento:
        movl    inicioReg, %ecx
        movl    %ecx, head
        movl    %ecx, tail

        movl    $0, (%ecx)
        
        addl    $1, tamList

        RET

    _insereHead:
        movl    inicioReg, %ecx
        addl    bytesAteProximo, %ecx

        movl    head, %edi
        movl    %edi, (%ecx)

        movl    inicioReg, %ecx
        movl    %ecx, head

        addl    $1, tamList

        RET

    _insereTail:
        movl    pai, %edi
        movl    inicioReg, %ebx

        addl    bytesAteProximo, %edi
        movl    %ebx, (%edi)
        movl    %ebx, tail

        addl    bytesAteProximo, %ebx
        movl    $0, (%ebx)

        RET

    _insereAntesFilho:
        movl    pai, %edi
        movl    filho, %ebx
        movl    inicioReg, %ecx
        
        addl    bytesAteProximo, %edi
        movl    %ecx, (%edi)

        addl    bytesAteProximo, %ecx

        movl    %ebx, (%ecx)

        addl $1, tamList

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
    pushl	tamNome
    pushl	%edi
    call	fgets

    popl	%edi
    addl	$8, %esp 
    addl	tamNome, %edi 

    # CELULAR

    pushl	%edi
    
    pushl	$msgCelular
    call	printf
    addl	$4, %esp

    pushl	$tipoNum
    call	scanf

    addl	$4, %esp
    popl	%edi
    movl	(%edi),%eax
    movl	%eax, tamCelular

    addl	tamCelular, %edi
    
    pushl	stdin
    pushl	$20
    pushl	$limpaScan
    call	fgets
    addl	$12, %esp

    # TIPO DE IMÓVEL (CASA OU APARTAMENTO)

    pushl   %edi

    pushl	$msgTipoImovel
    call	printf
    addl	$4, %esp
    popl    %edi

    pushl	stdin
    pushl	tamTipoImovel
    pushl	%edi
    call	fgets

    popl	%edi
    addl 	$8, %esp
    addl 	tamTipoImovel, %edi 

    # ENDEREÇO
    pushl   %edi

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
    pushl	tamCidade
    pushl	%edi
    call	fgets

    popl	%edi
    addl 	$8, %esp
    addl	tamCidade, %edi

    # BAIRRO

    pushl	%edi
    pushl	$msgBairro
    call	printf
    addl	$4, %esp 
    popl 	%edi

    pushl	stdin
    pushl	tamBairro
    pushl	%edi
    call	fgets

    popl	%edi
    addl	$8, %esp
    addl	tamBairro, %edi

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
    movl	%eax, totalQuartos
    addl	tamQuartos, %edi

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
    addl	%eax, totalQuartos
    addl	tamQuartos, %edi 

    pushl	stdin
    pushl	$20
    pushl	$limpaScan
    call	fgets
    addl	$12, %esp 

    # GARAGEM

    pushl	%edi

    pushl	$msgGaragem
    call	printf
    addl	$4, %esp 
    popl 	%edi

    pushl	stdin
    pushl	tamGaragem
    pushl	%edi
    call	fgets

    popl	%edi
    addl	$8, %esp 
    addl	tamGaragem, %edi 

    # METRAGEM

    pushl	%edi

    pushl	$msgMetragem
    call	printf
    addl	$4, %esp 

    pushl	$tipoNum
    call	scanf

    addl   	$4,%esp
    popl	%edi
    addl	tamMetragem, %edi 

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
    addl    tamAluguel, %edi

    pushl	$limpaScan
    pushl   $Char
    call 	scanf
    addl    $8, %esp 

    # Colocamos número de comodos no final
    movl    totalQuartos, %eax
    movl    %eax, (%edi)
    addl    $4, %edi

	# FIM DO REGISTRO, COLOCA 0 NO FINAL
    movl 	$0, %eax
    movl   	%eax, (%edi)

    movl    inicioReg, %edi
    call    insereEOrdena
    RET


limpaScanf:
	# LIMPA BUFFER DE LEITURA DAS FUNÇÕES SCANF E FGETS	

	pushl	$limpaScan
	pushl   $Char
	call 	scanf
	addl    $8, %esp 
	RET

consulta:
    pushl   $msgPedeReg
    call    printf
    addl    $4, %esp

    pushl   $nQuartosConsulta
    pushl   $tipoNum
    call    scanf
    addl   $8, %esp

    movl    head, %edi
    cmpl    $0, %edi
    je      _fimConsulta

    movl    %edi, regAtual
    
    _loopConsulta:
        movl    regAtual, %edi
        movl    $0, %eax
        addl    bytesAteQuartos, %edi
        movl    (%edi), %eax
        movl    %eax, totalQuartos

        cmpl    nQuartosConsulta, %eax
        je      _mostraReg

    _maisUmReg:
        movl    regAtual, %edi
        addl    bytesAteProximo, %edi
        cmpl    $0, (%edi)
        je      _fimConsulta

        movl    (%edi), %ecx
        movl    %ecx, regAtual
        jmp     _loopConsulta

    _mostraReg:
        movl    regAtual, %edi

        #Nome
        pushl   %edi
        pushl   $mostraNome
        call    printf
        addl    $8, %esp
        addl    tamNome, %edi

        #Celular
        pushl   (%edi)
        pushl   $mostraCelular
        call    printf
        addl    $8, %esp
        addl    tamCelular, %edi

        #Tipo Imovel
        pushl   %edi
        pushl   $mostraTipoImovel
        call    printf
        addl    $8, %esp
        addl    tamTipoImovel, %edi

        #Endereço
        pushl   $mostraEndereco
        call    printf
        addl    $4, %esp

        #Cidade
        pushl   %edi
        pushl   $mostraCidade
        call    printf
        addl    $8, %esp
        addl    tamCidade, %edi

        #Bairro
        pushl   %edi
        pushl   $mostraBairro
        call    printf
        addl    $8, %esp
        addl    tamBairro, %edi
        
        #Numero Quartos
        pushl   (%edi)
        pushl   $mostraNQuartos
        call    printf
        addl    $8, %esp
        addl    tamQuartos, %edi

        #Numero Suites
        pushl   (%edi)
        pushl   $mostraNSuites
        call    printf
        addl    $8, %esp
        addl    tamQuartos, %edi
        
        #Garagem
        pushl   %edi
        pushl   $mostraGaragem
        call    printf
        addl    $8, %esp
        addl    tamGaragem, %edi

        #Metragem
        pushl   %edi
        pushl   $mostraMetragem
        call    printf
        addl    $8, %esp
        addl    tamMetragem, %edi

        #Aluguel
        pushl   %edi
        pushl   $mostraAluguel
        call    printf
        addl    $8, %esp
        addl    tamAluguel, %edi

        #Total Quartos + Suites
        pushl   (%edi)
        pushl   $mostraNTotal
        call    printf
        addl    $8, %esp
        addl    tamQuartos, %edi

        jmp     _maisUmReg


    _fimConsulta:
        pushl   $msgSemRegs
        call    printf
        addl    $4, %esp
        RET
    
relatorio:

    movl    head, %edi
    movl    $0, iteracao

    movl    $0, %ebx
    cmpl    %edi, %ebx
    je      _semRegistros

    _loopRelatorio:
        pushl   iteracao
        pushl   $msgNumReg
        call    printf
        addl    $8, %esp

        # NOME
        pushl   %edi
        pushl   $mostraNome
        call    printf
        addl    $8, %esp
        addl    tamNome, %edi

        # CELULAR
        pushl   (%edi)
        pushl   $mostraCelular
        call    printf
        addl    $8, %esp
        addl    tamCelular, %edi
        # TIPO IMÓVEL
        pushl   %edi
        pushl   $mostraTipoImovel
        call    printf
        addl    $8, %esp
        addl    tamTipoImovel, %edi
        # ENDEREÇO
        pushl   $mostraEndereco
        call    printf
        addl    $4, %esp
        
        # CIDADE 
        pushl   %edi
        pushl   $mostraCidade
        call    printf
        addl    $8, %esp
        addl    tamCidade, %edi

        # BAIRRO
        pushl   %edi
        pushl   $mostraBairro
        call    printf
        addl    $8, %esp
_bantes:
        addl    tamBairro, %edi
_bdepois:
        # QUARTOS
        pushl   (%edi)
        pushl   $mostraNQuartos
        call    printf
        addl    $8, %esp
        addl    tamQuartos, %edi

        # SUITES
        pushl   (%edi)
        pushl   $mostraNSuites
        call    printf
        addl    $8, %esp
        addl    tamQuartos, %edi

        # GARAGEM 
        pushl   %edi
        pushl   $mostraGaragem
        call    printf
        addl    $8, %esp
        addl    tamGaragem, %edi

        # METRAGEM
        pushl   (%edi)
        pushl   $mostraMetragem
        call    printf
        addl    $8, %esp
        addl    tamMetragem, %edi

        # ALUGUEL
        pushl   (%edi)
        pushl   $mostraAluguel
        call    printf
        addl    $8, %esp
        addl    tamAluguel, %edi

        # TOTAL QUARTOS + SUÍTES
        pushl   (%edi)
        pushl   $mostraNTotal
        call    printf
        addl    $8, %esp
        addl    tamQuartos, %edi

        _proximoRegRelatorio:
            movl    (%edi), %eax
            cmpl    $0, %eax
            je      _fimRelatorio

            addl    $1, iteracao

            jmp     _loopRelatorio

    _fimRelatorio:
        RET

    _semRegistros:
        pushl   $msgSemRegs
        call    printf
        addl    $4, %esp

        RET
        