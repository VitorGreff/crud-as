.section .data

    #######################################################################
    # PRINTS

    msgAbertura:            .asciz  "\nControle de cadastro de imóveis para locação\n"
    menu:                   .asciz  "\n\nMENU\nSelecione uma das opções: \n[1] Inserir um registro\n[2] Consultar um registro\n[3] Remover um registro\n[4] Mostrar relatório\n[5] Gravar registros\n[6] Recuperar registros\n[7] Sair\nOpção: "
    opInvalida:             .asciz  "\nSelecione uma opção válida: \n"

    msgNome:                .asciz  "\nDigite o nome completo: " #32 bytes
    msgCelular:             .asciz  "\nDigite o telefone celular: " #16bytes
    msgTipoImovel:          .asciz  "\nEscolha o tipo de imóvel [casa/apartamento]: " #16 bytes
    msgEndereco:            .asciz  "\nInforme o endereço: " #64 bytes
    msgCidade:              .asciz  "\n Cidade: " #32 
    msgBairro:              .asciz  "\n Bairro: " #32
    msgNQuartos:            .asciz  "\nInforme o número de quartos simples: " #4bytes
    msgNSuites:             .asciz  "\nInforme o número de suítes: " #4bytes
    msgGaragem:             .asciz  "\nTem garagem? [S/N]: " #4bytes
    msgMetragem:            .asciz  "\nQual a metragem total? " #4bytes
    msgAluguel:             .asciz  "\nQual o valor do aluguel? " #4bytes    

    msgNumReg:              .asciz  "\n\nREGISTRO: %d"
    mostraNome:             .asciz  "\nNome:    %s"
    mostraCelular:          .asciz  "Celular: %s"
    mostraTipoImovel:       .asciz  "Tipo do Imóvel: %s"
    mostraEndereco:         .asciz  "Endereço: "
    mostraCidade:           .asciz  "\n Cidade:  %s"
    mostraBairro:           .asciz  " Bairro:  %s"
    mostraNQuartos:         .asciz  "Quartos: %d"
    mostraNSuites:          .asciz  "\nSuítes:  %d"
    mostraGaragem:          .asciz  "\nGaragem? %s"
    mostraMetragem:         .asciz  "Metragem Total: %d"
    mostraAluguel:          .asciz  "\nValor do aluguel: %d"
    mostraNTotal:           .asciz  "\nTotal de quartos e suítes: %d\n"

    msgSemRegs:             .asciz  "\nNão há registros\n"
    msgRegNaoEncontrado:    .asciz  "\nO registro desejado não foi encontrado.\n"
    msgRegRemovido:         .asciz  "\nRegistro removido com sucesso!\n"
    msgGravacaoArquivo:     .asciz  "\nGravação no arquivo concluída com sucesso!\n"
    msgRecuperacao:         .asciz  "\nRecuperação de registros concluída com sucesso!\n"

    msgPedeNQuartos:        .asciz  "\nDigite um número de quartos para consulta: "
    msgPedeIndiceReg:       .asciz  "\nDigite o número do registro que deseja remover: " 

    #######################################################################
    # VARIÁVEIS

    tamNome:                .int 32
    tamCelular:             .int 16
    tamTipoImovel:          .int 16
    tamCidade:              .int 32
    tamBairro:              .int 32
    tamQuartos:             .int 4
    # tamSuite              4 bytes 
    tamGaragem:             .int 4
    tamMetragem:            .int 4
    tamAluguel:             .int 4
    # tamTotalQuartos       4 bytes 

    tamReg:                 .int   156

    bytesAteQuartos:        .int 148
    bytesAtePonteiro:       .int 152

    tipoNum: 			    .asciz 	"%d"
	Char:			        .asciz	"%c"
	Str:			        .asciz	"%s"

    op:                     .int   0
    removeReg:              .int   0
    limpaScan:              .space 10

	head:			        .space  4	
    tail:   			    .space 	4
	pai:					.space	4	
	filho:					.space	4	
	
    inicioReg:			    .space	4
	regAtual:       	    .space  4 
	enderecoRegRemocao:		.space 	4	

    reg:                    .space 156
	totalQuartos:			.int 	0

	indice:			        .int	0
	nQuartosConsulta:       .int	0
    numRegRemocao:          .int    0

	nomeArq:			    .asciz	"registrosImobiliaria.txt"

.section .bss
    .lcomm  arquivoHandle, 4

.section    .text
.globl      _start
_start:
    pushl   $msgAbertura
    call    printf
    addl    $4, %esp            # mensagem de abertura  

	call	recuperar           # recupera registros do arquivo
	call	menuOpcoes          # chama menu principal

_fim:
	pushl   $0
	call    exit

menuOpcoes:
    pushl   $menu
    call    printf
    pushl   $op
    pushl   $tipoNum
    call    scanf               # pede opção do menu

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
    je      _gravaReg

    # RECUPERAR
    cmpl    $6, op
    je      _recuperaReg

    # FINALIZAÇÃO
    cmpl    $7, op
    je      _fim

    # Se chegou até aqui, opção inválida
    pushl   $opInvalida 
    call    printf
    addl    $4, %esp
    jmp     menuOpcoes

    _insereReg:
        call    limpaBuffer         # limpa buffer para poder utilizar o fgets
        call    inserir
        jmp     menuOpcoes

    _consultaReg:   
        call    consulta
        jmp     menuOpcoes

    _removeReg:
        call    remove
        jmp     menuOpcoes

    _mostraRelatorio:
        call    relatorio
        jmp     menuOpcoes

    _gravaReg:
        call    gravar
        jmp     menuOpcoes

    _recuperaReg:
        call    recuperar
        jmp     menuOpcoes


insereEOrdena:
    movl    inicioReg, %ecx            
    addl    bytesAteQuartos, %ecx       
    
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
    addl    bytesAtePonteiro, %edi
    cmpl    $0, (%edi)
    je      _insereTail

    movl    pai, %edi
    addl    bytesAtePonteiro, %edi
    movl    (%edi), %eax
    movl    %eax, filho

    movl    inicioReg, %ecx
    addl    bytesAteQuartos, %ecx

    _loopInsercao:
        movl    pai, %edi
        movl    filho, %ebx

        addl    bytesAtePonteiro, %edi

        addl    bytesAteQuartos, %ebx
        movl    (%ecx), %eax
        cmpl    (%ebx), %eax
        jle     _insereAntesFilho

        movl    filho, %ebx
        movl    %ebx, pai

        movl    pai, %edi
        addl    bytesAtePonteiro, %edi
        cmpl    $0, (%edi)
        je      _insereTail

        movl    (%edi), %eax
        movl    %eax, filho
        jmp     _loopInsercao

    _inserePrimeiroElemento:

        movl    inicioReg, %ecx
        movl    %ecx, head
        movl    %ecx, tail
        addl    bytesAtePonteiro, %ecx
        movl    $0, (%ecx)

        RET

    _insereHead:

        movl    inicioReg, %ecx
        addl    bytesAtePonteiro, %ecx

        movl    head, %edi
        movl    %edi, (%ecx)

        movl    inicioReg, %ecx
        movl    %ecx, head

        RET

    _insereTail:
        movl    pai, %edi
        movl    inicioReg, %ebx

        addl    bytesAtePonteiro, %edi
        movl    %ebx, (%edi)
        movl    %ebx, tail

        addl    bytesAtePonteiro, %ebx
        movl    $0, (%ebx)

        RET

    _insereAntesFilho:
        movl    pai, %edi
        movl    filho, %ebx
        movl    inicioReg, %ecx
        
        addl    bytesAtePonteiro, %edi
        movl    %ecx, (%edi)

        addl    bytesAtePonteiro, %ecx
        movl    %ebx, (%ecx)

        RET


inserir:
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

    popl	%edi

    pushl	stdin
    pushl	tamCelular
    pushl	%edi
    call	fgets

    popl    %edi
    addl	$8, %esp
    addl    tamCelular, %edi

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


limpaBuffer:
	# LIMPA BUFFER DE LEITURA 

	pushl	$limpaScan
	pushl   $Char
	call 	scanf
	addl    $8, %esp 
	RET

printReg:
    # NOME
    pushl   %edi
    pushl   $mostraNome
    call    printf
    addl    $8, %esp
    addl    tamNome, %edi

    # CELULAR
    pushl   %edi
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
    addl    tamBairro, %edi
    
    # NÚMERO DE QUARTOS
    pushl   (%edi)
    pushl   $mostraNQuartos
    call    printf
    addl    $8, %esp
    addl    tamQuartos, %edi

    # NÚMERO DE SUÍTES
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
    
    RET

consulta:
    pushl   $msgPedeNQuartos
    call    printf
    addl    $4, %esp

    pushl   $nQuartosConsulta
    pushl   $tipoNum
    call    scanf
    addl   $8, %esp

    movl    head, %edi
    cmpl    $0, %edi
    je      _fimConsultaSemReg

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
        addl    bytesAtePonteiro, %edi
        cmpl    $0, (%edi)
        je      _fimConsulta

        movl    (%edi), %ecx
        movl    %ecx, regAtual
        jmp     _loopConsulta

    _mostraReg:
        movl    regAtual, %edi

        call    printReg

        jmp     _maisUmReg


    _fimConsultaSemReg:
        pushl   $msgSemRegs
        call    printf
        addl    $4, %esp

    _fimConsulta:
        RET

remove:
    call    relatorio

    cmpl    $0, head
    je      _listaVazia

    pushl   $msgPedeIndiceReg
    call    printf
    addl    $4, %esp

    pushl   $numRegRemocao
    pushl   $tipoNum
    call    scanf
    addl    $8, %esp

    cmpl    $0, numRegRemocao
    je      _removeHead

    movl    $0, indice
    movl    head, %edi
    movl    %edi, pai

    addl    bytesAtePonteiro, %edi 
    movl    (%edi), %ebx
    movl    %ebx, filho

    decl    numRegRemocao

    _loopRemocao:
        cmpl    $0, filho 
        je      _falhaRemocao

        movl    indice, %eax
        cmpl    %eax, numRegRemocao
        je      _removeProximo

        incl    %eax
        movl    %eax, indice

        movl    pai, %edi
        movl    filho, %ebx
        movl    %ebx, pai
        addl    bytesAtePonteiro, %ebx
        movl    (%ebx), %ecx
        movl    %ecx, filho

        jmp     _loopRemocao

    _removeHead:
        movl    head, %edi
        movl    %edi, enderecoRegRemocao
        addl    bytesAtePonteiro, %edi
        movl    (%edi), %eax
        movl    %eax, head

        pushl   enderecoRegRemocao
        call    free
        addl    $4, %esp

        pushl   $msgRegRemovido
        call    printf
        addl    $4, %esp

        RET

    _removeProximo:
        movl    filho, %edi
        movl    %edi, enderecoRegRemocao
        addl    bytesAtePonteiro, %edi
        movl    (%edi), %eax
        movl    %eax, filho

        movl    pai, %ecx
        addl    bytesAtePonteiro, %ecx
        movl    filho, %edi
        movl    %edi, (%ecx)

        pushl   enderecoRegRemocao
        call    free
        addl    $4, %esp

        cmpl    $0, %eax
        jne      _fimRemove

        movl    pai, %edi
        movl    %edi, tail

        pushl   $msgRegRemovido
        call    printf
        addl    $4, %esp

        jmp     _fimRemove

    _falhaRemocao:
        pushl   $msgRegNaoEncontrado
        call    printf
        addl    $4, %esp

        jmp     _fimRemove

    _listaVazia:
    _fimRemove:
        RET

relatorio:

    movl    head, %edi
    movl    $0, indice

    movl    $0, %ebx
    cmpl    %edi, %ebx
    je      _semRegistros

    _loopRelatorio:
        pushl   indice
        pushl   $msgNumReg
        call    printf
        addl    $8, %esp

        call    printReg

        _proximoRegRelatorio:
            movl    (%edi), %eax
            cmpl    $0, %eax
            je      _fimRelatorio

            addl    $1, indice

            movl    (%edi), %edi

            jmp     _loopRelatorio


    _semRegistros:
        pushl   $msgSemRegs
        call    printf
        addl    $4, %esp

    _fimRelatorio:
        RET

abrirArquivoLeitura:
    movl    $5, %eax
    movl    $nomeArq, %ebx         
    movl    $02100, %ecx            # somente leitura
    movl    $0777, %edx            # todos os acessos para todos
    int     $0x80
    test    %eax, %eax              # verifica se o arquivo é válido
    js      badfile
    movl    %eax, arquivoHandle    # identificador do arquivo1 em
    
    RET

abrirArquivoEscrita:
    movl    $5, %eax
    movl    $nomeArq, %ebx         
    movl    $01101, %ecx            # somente escrita, cria arquivo se não existe
                                    # e escreve no final do arquivo
    movl    $0777, %edx             # somente escrita para todos
    int     $0x80
    test    %eax, %eax              # verifica se o arquivo é válido
    js      badfile
    movl    %eax, arquivoHandle    # identificador do arquivo1 em
	
    RET

fecharArquivo:
    movl    $6, %eax
    movl    arquivoHandle, %ebx
    int     $0x80

    RET

gravar:
    call    abrirArquivoEscrita
    
    movl    head, %edi
    movl    %edi, regAtual

    _loopGravacao:
        cmpl    $0, regAtual
        je      _fimGravacao

        movl    $4, %eax
        movl    arquivoHandle, %ebx
        movl    regAtual, %ecx
        movl    tamReg, %edx
        int     $0x80

        movl    regAtual, %edi
        addl    bytesAtePonteiro, %edi
        movl    (%edi), %edi
        movl    %edi, regAtual
        
        jmp     _loopGravacao

    _fimGravacao:
        call    fecharArquivo

        pushl   $msgGravacaoArquivo
        call    printf
        addl    $4, %esp

        RET

recuperar:
    call    abrirArquivoLeitura
    movl    $0, indice

    _loopRecuperacao:
        pushl   tamReg
        call    malloc
        movl    %eax, inicioReg
        addl    $4, %esp

        movl    $3, %eax
        movl    arquivoHandle, %ebx
        movl    inicioReg, %ecx
        movl    tamReg, %edx
        int     $0x80

        cmpl    $0, %eax
        je      _fimRecuperacao

        movl    inicioReg, %edi
        addl    bytesAtePonteiro, %edi
        movl    $0, (%edi)

        cmpl    $0, indice
        je      _defineHead

        call insereEOrdena

        jmp _loopRecuperacao

    _defineHead:
        movl    inicioReg, %edi
        movl    %edi, head
        movl    %edi, tail

        addl    bytesAtePonteiro, %edi
        movl    $0, (%edi)

        incl    indice

        jmp     _loopRecuperacao

    _fimRecuperacao:
        call    fecharArquivo

        cmpl    $0, indice
        je      _arquivoVazio

        pushl   $msgRecuperacao
        call    printf
        addl    $4, %esp

        RET

    _arquivoVazio:
        movl    $0, head
        
        pushl   $msgSemRegs
        call    printf
        addl    $4, %esp

        RET

badfile:
    movl    %eax, %ebx
    movl    $1, %eax
    int     $0x80
