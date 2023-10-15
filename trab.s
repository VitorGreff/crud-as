# Trabalho 2 - PIHS
# Controle de cadastro de imóveis para locação
# Desenvolvido por:
#   Rômulo Barreto Mincache     RA 117477
#   Vitor Augusto Greff         RA 118926

.section .data

    #######################################################################
    # PRINTS

    msgAbertura:            .asciz  "\nControle de cadastro de imóveis para locação\n"
    menu:                   .asciz  "\n\nMENU\nSelecione uma das opções: \n[1] Inserir um registro\n[2] Consultar um registro\n[3] Remover um registro\n[4] Mostrar relatório\n[5] Gravar registros\n[6] Recuperar registros\n[7] Sair\nOpção: "
    opInvalida:             .asciz  "\nSelecione uma opção válida: \n"

    msgNome:                .asciz  "\nDigite o nome completo: " #32 bytes
    msgCelular:             .asciz  "\nDigite o telefone celular: " #16 bytes
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

    tipoNum: 			    .asciz 	"%d"
	Char:			        .asciz	"%c"
	Str:			        .asciz	"%s"

    #######################################################################
    # VARIÁVEIS

    tamNome:                .int    32
    tamCelular:             .int    16
    tamTipoImovel:          .int    16
    tamCidade:              .int    32
    tamBairro:              .int    32
    tamQuartos:             .int    4
    # tamSuite                      4 bytes 
    tamGaragem:             .int    4
    tamMetragem:            .int    4
    tamAluguel:             .int    4
    # tamTotalQuartos               4 bytes 
    # tamPonteiro                   4 bytes    

    tamReg:                 .int    156
    reg:                    .space  156

    bytesAteQuartos:        .int    148         # num de bytes até chegarmos no campo número de quartos
    bytesAtePonteiro:       .int    152         # num de bytes até chegarmos no campo do ponteiro

    op:                     .int    0
    removeReg:              .int    0
    limpaScan:              .space  10

	head:			        .space  4	
    tail:   			    .space 	4
	pai:					.space	4	
	filho:					.space	4	
	
    inicioReg:			    .space	4
	regAtual:       	    .space  4 
	enderecoRegRemocao:		.space 	4	

	totalQuartos:			.int 	0

	indice:			        .int	0
	nQuartosConsulta:       .int	0
    numRegRemocao:          .int    0

	nomeArq:			    .asciz	"registrosImobiliaria.txt"

.section .bss
    .lcomm  identificadorArquivo, 4

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
    movl    inicioReg, %ecx             # inicioReg é o endereço inicial do reg a ser inserido
    addl    bytesAteQuartos, %ecx       # leva até o endereço que contém o número de quartos no registro 
    
    cmpl    $0, head                    # verifica se a lista está vazia
    je      _inserePrimeiroElemento     # se sim, insere na head

    movl    head, %edi
    movl    %edi, pai

    addl    bytesAteQuartos, %edi       # leva até o endereço que contém o número de quartos no registro
    movl    (%edi), %eax
    cmpl    %eax, (%ecx)                # verifica se o total de quartos do reg a ser inserido é
                                        # menor que o do primeiro reg
    jle     _insereHead                 # se for, insere na red

    movl    pai, %edi                   
    addl    bytesAtePonteiro, %edi      # leva até o endereço do ponteiro
    cmpl    $0, (%edi)                  # verifica se o ponteiro é 0, ou seja, único da lista
    je      _insereTail                 # se sim, insere no tail

    movl    pai, %edi
    addl    bytesAtePonteiro, %edi      
    movl    (%edi), %eax
    movl    %eax, filho                 # coloca o endereço do próximo registro no filho

    movl    inicioReg, %ecx
    addl    bytesAteQuartos, %ecx       # se chegou até aqui, não entrou nos caso base da inserção

    _loopInsercao:
        # no loop de inserção, temos duas possibilidades: 
        # * inserir antes do filho (entre registro atual e próximo)
        # * inserir no fim da lista

        movl    filho, %ebx

        addl    bytesAteQuartos, %ebx
        movl    (%ecx), %eax
        cmpl    (%ebx), %eax
        jle     _insereAntesFilho           # verifica se será inserido entre reg atual e próximo
                                            # ou seja, se tem - quartos que o proximo reg

        movl    filho, %ebx
        movl    %ebx, pai                   # vai para o próximo registro

        movl    pai, %edi
        addl    bytesAtePonteiro, %edi
        cmpl    $0, (%edi)
        je      _insereTail                 # verifica se é o último reg

        movl    (%edi), %eax
        movl    %eax, filho                 # vai para o próximo registro
        jmp     _loopInsercao

    _inserePrimeiroElemento:
        # primeiro registro a ser inserido na lista vazia

        movl    inicioReg, %ecx             
        movl    %ecx, head
        movl    %ecx, tail                  # coloca o endereço do registro tanto em head quanto em tail
        addl    bytesAtePonteiro, %ecx      
        movl    $0, (%ecx)                  # seta o ponteiro no final do registro como 0
                                            # indica que o ponteiro é vazio
        RET

    _insereHead:
        # insere na head, a primeira posição

        movl    inicioReg, %ecx
        addl    bytesAtePonteiro, %ecx

        movl    head, %edi
        movl    %edi, (%ecx)                # coloca a head antiga no ponteiro do novo primerio registro

        movl    inicioReg, %ecx 
        movl    %ecx, head                  # seta no novo primeiro reg como a head

        RET

    _insereTail:
        # insere na tail, o final da lista

        movl    pai, %edi                   # pai aqui é o último elemento
        movl    inicioReg, %ebx

        addl    bytesAtePonteiro, %edi      
        movl    %ebx, (%edi)
        movl    %ebx, tail                  # move o endereço do novo reg tanto para o ponteiro do último
                                            # quanto para a tail

        addl    bytesAtePonteiro, %ebx      # zera o ponetiro do novo último registro
        movl    $0, (%ebx)

        RET

    _insereAntesFilho:
        # insere entre o registro que está olhando e o próximo

        movl    pai, %edi
        movl    filho, %ebx
        movl    inicioReg, %ecx
        
        addl    bytesAtePonteiro, %edi
        movl    %ecx, (%edi)                # coloca o endereço do novo reg no ponteiro de pai

        addl    bytesAtePonteiro, %ecx
        movl    %ebx, (%ecx)                # coloca o endereço do filho no ponteiro do novo reg

        RET


inserir:
    pushl	tamReg
    call	malloc
    movl	%eax, inicioReg
    movl	inicioReg, %edi
    addl	$4, %esp            # aloca memória para o registro e guarda o endereço em inicioReg

    # pede todos os campos do registro
    # quando será lida string, pedimos com fgets para poder ser digitado espaço
    # para inteiros, lemos com scanf mesmo

	# NOME
    pushl	$msgNome
    call	printf
    addl	$4, %esp 

    pushl	stdin               # qual o dispositivo de entrada
    pushl	tamNome             # tamanho do que será lido
    pushl	%edi                # endereço onde será armazenado
    call	fgets

    popl	%edi
    addl	$8, %esp 
    addl	tamNome, %edi       # somamos sempre o tamanho do campo que foi lido em edi

    # até o fim da função, segue essa mesma estrutura para as próximas leituras

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

    call    limpaBuffer             # como a próxima leitura será com fgets, precisamos limpar o buffer

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

    # Colocamos número total de quartos no final do registro
    movl    totalQuartos, %eax
    movl    %eax, (%edi)
    addl    $4, %edi

	# FIM DO REGISTRO
    movl 	$0, %eax
    movl   	%eax, (%edi)            # colocamos 0 no campo do ponteiro

    movl    inicioReg, %edi
    call    insereEOrdena           # chamamos a função para inserir o novo reg na lista
    RET


limpaBuffer:
	# limpa o buffer de leitura

	pushl	$limpaScan
	pushl   $Char
	call 	scanf
	addl    $8, %esp 
	RET

printReg:
    # percorre pelo edi, printando cada campo do registro

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
    addl   $8, %esp                 # pede número de quartos a ser consultado

    movl    head, %edi
    cmpl    $0, %edi
    je      _fimConsultaListaVazia  # verifica se a head é 0, ou seja, lista vazia

    movl    $0, indice              # indice indicará o número do registro no print, estético

    movl    %edi, regAtual          # regAtual guarda o registro para o qual estamos olhando
    
    _loopConsulta:
        movl    regAtual, %edi          
        addl    bytesAteQuartos, %edi
        movl    (%edi), %eax
        cmpl    nQuartosConsulta, %eax      # verifica se num quartos do regAtual é o mesmo número  
                                            # que estamos buscando
        je      _mostraReg                  # se for, mostra o registro

    _maisUmReg:
        movl    regAtual, %edi              
        addl    bytesAtePonteiro, %edi
        cmpl    $0, (%edi)                  # verifica se regAtual é o último registro da lista
        je      _fimConsulta                # se for, encerra a consulta

        movl    (%edi), %ecx
        movl    %ecx, regAtual
        jmp     _loopConsulta               # passa o endereço no ponteiro para regAtual,
                                            # preparando a busca no próximo registro

    _mostraReg:
        pushl   indice
        pushl   $msgNumReg
        call    printf
        addl    $8, %esp                    # printa o número do registro encontrado, estético

        incl    indice

        movl    regAtual, %edi
        call    printReg                    # coloca regAtual em edi para ser printado

        jmp     _maisUmReg                  # volta a buscar por outros registros com o mesmo num de quartos


    _fimConsultaListaVazia:
        pushl   $msgSemRegs
        call    printf
        addl    $4, %esp                    # mensagem de lista vazia

    _fimConsulta:
        RET

remove:
    # a remoção será feita através do índice do registro na lista

    call    relatorio               # printa todos os registros, para o usuário ver qual o índice do reg

    cmpl    $0, head                # verifica se a lista está vazia
    je      _listaVazia 

    pushl   $msgPedeIndiceReg
    call    printf
    addl    $4, %esp
    pushl   $numRegRemocao
    pushl   $tipoNum
    call    scanf
    addl    $8, %esp                # pede o índice do registro a ser removido

    cmpl    $0, numRegRemocao       # se for 0, remove a head
    je      _removeHead             

    movl    $0, indice
    movl    head, %edi
    movl    %edi, pai               

    addl    bytesAtePonteiro, %edi 
    movl    (%edi), %ebx
    movl    %ebx, filho             # setando indice, head, pai e filho

    decl    numRegRemocao

    _loopRemocao:
        # será removido o registro filho do que estamos olhando

        cmpl    $0, filho 
        je      _falhaRemocao       # se o fiho for 0, indica que chegamos ao fim da lista e
                                    # o índice escolhido não foi encontrado

        movl    indice, %eax        
        cmpl    %eax, numRegRemocao     # verifica se o indice escolhido é o índice atual
        je      _removeFilho              # se for, iremos remover o registro filho

        incl    indice                  

        movl    filho, %ebx
        movl    %ebx, pai
        addl    bytesAtePonteiro, %ebx
        movl    (%ebx), %ecx
        movl    %ecx, filho             # colocamos o filho em novo pai, e seu filho em filho
                                        # preparando para continuar a busca

        jmp     _loopRemocao

    _removeHead:
        # removeremos o primeiro elemento da lista, ínidice escolhido foi 0

        movl    head, %edi                  
        movl    %edi, enderecoRegRemocao
        addl    bytesAtePonteiro, %edi
        movl    (%edi), %eax
        movl    %eax, head                  # colocamos o filho de head como novo head

        pushl   enderecoRegRemocao
        call    free
        addl    $4, %esp                    # liberamos o espaço alocado para o arquivo que foi removido

        pushl   $msgRegRemovido
        call    printf
        addl    $4, %esp                    # mensagem de remoção com sucesso

        jmp     _fimRemove

    _removeFilho:
        # o registro a ser removido é o filho do registro que estamos olhando

        movl    filho, %edi             
        movl    %edi, enderecoRegRemocao
        addl    bytesAtePonteiro, %edi
        movl    (%edi), %eax
        movl    %eax, filho                 # colocamos o filho do filho como novo filho

        movl    pai, %ecx
        addl    bytesAtePonteiro, %ecx
        movl    filho, %edi
        movl    %edi, (%ecx)                # encadeamos o novo filho no pai

        pushl   enderecoRegRemocao
        call    free
        addl    $4, %esp                    # liberamos o espaço alocado

        cmpl    $0, %eax
        jne      _fimRemove                 # o que tem no eax é o filho do filho
                                            # se ele era 0, indica que o removido era o último

        movl    pai, %edi
        movl    %edi, tail                  # se o removido era o último, atualizamos a tail

        pushl   $msgRegRemovido             
        call    printf
        addl    $4, %esp                    # mensagem de registro removido com sucesso

        jmp     _fimRemove

    _falhaRemocao:
        pushl   $msgRegNaoEncontrado
        call    printf      
        addl    $4, %esp                    # mensagem de registro não encontrado

        jmp     _fimRemove

    _listaVazia:
    _fimRemove:
        RET

relatorio:

    movl    $0, indice              # coloca o índice dos registros como 0, estético

    movl    head, %edi              # head em edi para percorrer a lista
    cmpl    $0, %edi                # verifica se há registros na lista
    je      _semRegistros           # se não há, salta para a finalização do relatório

    _loopRelatorio:
        pushl   indice
        pushl   $msgNumReg
        call    printf
        addl    $8, %esp            # printa o número do registro

        call    printReg            # printa o registro em si

        _proximoRegRelatorio:
            movl    (%edi), %eax
            cmpl    $0, %eax        # verifica se há mais registros (ponteiro diferente de 0)
            je      _fimRelatorio   # se é o ponteiro é 0, é o último. salta para finalizar relatório

            incl    indice          # incrementa índice

            movl    (%edi), %edi    # passa o endereço no ponteiro para edi,
                                    # preparando para printar o próximo registro

            jmp     _loopRelatorio


    _semRegistros:
        pushl   $msgSemRegs
        call    printf
        addl    $4, %esp            # printa mensagem de lista vazia

    _fimRelatorio:
        RET
abrirArquivoLeitura:
    movl    $5, %eax                # chamada de sistema para abrir arquivo
    movl    $nomeArq, %ebx         
    movl    $02100, %ecx            # somente leitura
    movl    $0777, %edx             # todos os acessos para todos
    int     $0x80
    test    %eax, %eax              # verifica se o arquivo é válido
    js      badfile
    movl    %eax, identificadorArquivo     # setando identificador do arquivo 
    
    RET

abrirArquivoEscrita:
    movl    $5, %eax                # chamada de sistema para abrir arquivo
    movl    $nomeArq, %ebx         
    movl    $01101, %ecx            # somente escrita, cria arquivo se não existe
                                    # e escreve no final do arquivo
    movl    $0777, %edx             # somente escrita para todos
    int     $0x80
    test    %eax, %eax              # verifica se o arquivo é válido
    js      badfile
    movl    %eax, identificadorArquivo    # setando identificador do arquivo
	
    RET

fecharArquivo:
    movl    $6, %eax                    # chamada de sistema para fechar o arquivo
    movl    identificadorArquivo, %ebx
    int     $0x80

    RET

gravar:
    call    abrirArquivoEscrita                 # abrimos o arquivo
    
    movl    head, %edi
    movl    %edi, regAtual                      # colocamos head no regAtual, é o endereço inicial
                                                # do registro a ser gravado

    _loopGravacao:
        cmpl    $0, regAtual                    # se regAtual for 0, fim da lista
        je      _fimGravacao

        movl    $4, %eax                        # chamada de sistema para escrita no arquivo
        movl    identificadorArquivo, %ebx
        movl    regAtual, %ecx                  # será gravado o regAtual
        movl    tamReg, %edx
        int     $0x80

        movl    regAtual, %edi                  
        addl    bytesAtePonteiro, %edi
        movl    (%edi), %edi
        movl    %edi, regAtual                  # vamos até o próximo registro
        
        jmp     _loopGravacao

    _fimGravacao:
        call    fecharArquivo                   # fecha o arquivo

        pushl   $msgGravacaoArquivo
        call    printf
        addl    $4, %esp                        # mensagem de gravação com sucesso

        RET     

recuperar:
    call    abrirArquivoLeitura                 # abrimos o arquivo para leitura
    movl    $0, indice                          # indíce aqui só diz se já recuperamos um reg ou não

    _loopRecuperacao:
        pushl   tamReg                          
        call    malloc
        movl    %eax, inicioReg
        addl    $4, %esp                        # alocamos memória para o registro, endereço em inicioReg

        movl    $3, %eax                        # chamada de sistema para leitura do arquivo
        movl    identificadorArquivo, %ebx
        movl    inicioReg, %ecx                 # endereço do reg recuperado será inicioReg
        movl    tamReg, %edx
        int     $0x80

        cmpl    $0, %eax                        # se eax for 0, acabaram os registros do arquivo
        je      _fimRecuperacao                 # salta para fim da recuperação

        movl    inicioReg, %edi
        addl    bytesAtePonteiro, %edi
        movl    $0, (%edi)                      # colocamos 0 no campo de ponteiro do registro recuperado

        cmpl    $0, indice                      # se é o primeiro registro recuperado
        je      _defineHead                     # salta para definir ele como head

        call insereEOrdena                      # insere o arquivo na lista encadeada

        jmp _loopRecuperacao                    # loop para recuperar outros registros

    _defineHead:
        movl    inicioReg, %edi
        movl    %edi, head
        movl    %edi, tail                      # definimos registro recuperado como head e tail

        addl    bytesAtePonteiro, %edi
        movl    $0, (%edi)                      # colocamos 0 no campo ponteiro do registro

        incl    indice                          # incrementamos indice, mostrando que já recuperamos
                                                # um registro do arquivo

        jmp     _loopRecuperacao                # volta para recuperar mais

    _fimRecuperacao:                
        call    fecharArquivo                   # fecha o arquivo

        cmpl    $0, indice                      # se indice for 0, não recuperamos nenhum registro
        je      _arquivoVazio                   # arquivo vazio

        pushl   $msgRecuperacao                 
        call    printf
        addl    $4, %esp                        # mensagem de registros recuperados com sucesso

        RET

    _arquivoVazio:
        movl    $0, head                        # setamos head como 0
        
        pushl   $msgSemRegs
        call    printf
        addl    $4, %esp                        # mensagem de arquivo vazio

        RET

badfile:
    # erro no arquivo

    movl    %eax, %ebx
    movl    $1, %eax
    int     $0x80
