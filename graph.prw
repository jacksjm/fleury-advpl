#INCLUDE "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} GraphEuller
Objeto para Estruturar um Grafo
@type    Class
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Class GraphEuller
	Data aVertex
	Data aEdges
	Data aVisited
	Data aPath

	Method New( aVertex, aEdges )
	Method AddVertex( xVertex )
	Method AddNewVertex( aNewVertex , aNewEdges )
	Method FindVertex( xVertex )
	Method RemoveVertex( xVertex )
	Method AddEdge( aEdge )
	Method FindEdge( xVertex1, xVertex2 )
	Method FindAnythingEdge( xVertex )
	Method RemoveEdge( nEdge )
	Method CountEdge( xVertex )
	Method IsEulerGraph()
	Method FirstOddVertex()
	Method DFSCount( xVertFrom )
	Method validNextEdge( xVertexTo, xVertexFrom )
	Method listEuler( xVertex )

EndClass
//-------------------------------------------------------------------
/*/{Protheus.doc} New
Metodo Contrutor do Objeto

@param   aVertex, Array, Vertices do Grafo
@param   [aEdges], Array, Arestas do Grafo

@return  Object, Objeto do Grafo
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method New( aVertex, aEdges ) Class GraphEuller
	Local nEdge
	Local nVertex

	Default aEdges := {}

	//Inicializa os Vertices e Arestas
	Self:aVertex  := {}
	Self:aEdges   := {}
	Self:aVisited := {}
	Self:aPath    := {}

	//Adiciona os novos Vertices
	For nVertex := 1 To Len( aVertex )
		Self:AddVertex( aVertex[ nVertex ] )
	Next nVertex

	//Adiciona as Arestas
	For nEdge := 1 To Len( aEdges )
		Self:AddEdge( aClone( aEdges[ nEdge ] ) )
	Next nEdge

	Return Self
//-------------------------------------------------------------------
/*/{Protheus.doc} AddNewVertex
Adiciona Novos Vertices com suas Arestas ao Grafo

@param   aNewVertex, Array, Novos Verteces do Grafo
@param   [aNewEdges], Array, Novas Arestas do Grafo

@return  Nill, Sempre Nulo
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method AddNewVertex( aNewVertex , aNewEdges ) Class GraphEuller
	Local nEdge
	Local nVertex

	Default aNewEdges := {}

	//Adiciona os novos Vertices
	For nVertex := 1 To Len( nVertex )
		Self:AddVertex( aNewVertex[ nVertex ] )
	Next nVertex

	//Adiciona as novas Arestas
	For nEdge := 1 To Len( aNewEdges )
		Self:AddEdge( aClone( aNewEdges[ nEdge ] ) )
	Next nEdge

	Return
//-------------------------------------------------------------------
/*/{Protheus.doc} AddVertex
Adiciona um Vertice ao Grafo

@param   xVertex, Undefined, Valor correspondente ao Vertice

@return  Nill, Sempre Nulo
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method AddVertex( xVertex ) Class GraphEuller

	//Caso já tenha o Vertice não adiciona duas vezes
	If Self:FindVertex( xVertex ) == 0
		aAdd( Self:aVertex, xVertex )
	EndIf

	Return
//-------------------------------------------------------------------
/*/{Protheus.doc} FindVertex
Verifica se o Vertice já existe no Grafo

@param   xVertex, Undefined, Valor correspondente ao Vertice

@return  Numeric, Posição do Vertice no Grafo
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method FindVertex( xVertex ) Class GraphEuller
	Local nVertex := aScan( Self:aVertex , { | x | x == xVertex })
	Return nVertex
//-------------------------------------------------------------------
/*/{Protheus.doc} RemoveVertex
Remove o Vertice do Grafo

@param   xVertex, Undefined, Valor correspondente ao Vertice

@return  Nill, Sempre Nulo
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method RemoveVertex( xVertex ) Class GraphEuller

	//Verifica se o Vertex não tem nenhuma conexão
	If Self:FindAnythingEdge( xVertex ) == 0
		aDel( Self:aVertex, nVertex )
		aSize( Self:aVertex, Len( Self:aVertex ) - 1 )
	EndIf

	Return
//-------------------------------------------------------------------
/*/{Protheus.doc} AddEdge
Adiciona uma nova Aresta no Grafo

@param   aEdge, Array, Valor da Aresta do Grafo (Ex.: { 1 , 2 })

@return  Nill, Sempre Nulo
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method AddEdge( aEdge ) Class GraphEuller

	aAdd( Self:aEdges, aClone( aEdge ) )

	Return
//-------------------------------------------------------------------
/*/{Protheus.doc} FindEdge
Verifica se existe uma Aresta entre dois vertices

@param   xVertex, Undefined, Valor correspondente ao Vertice 1 de Busca
@param   xVertex, Undefined, Valor correspondente ao Vertice 2 de Busca

@return  Numeric, Posição da Aresta no Grafo
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method FindEdge( xVertex1, xVertex2 ) Class GraphEuller
	Local nEdge := aScan( Self:aEdges , { | x | x[ 1 ] == xVertex1 .And. x[ 2 ] == xVertex2 })

	//Caso não encontre a ligação A -> B procura B <- A pois o Grafo é Balanceado
	If nEdge == 0
		nEdge := aScan( Self:aEdges , { | x | x[ 2 ] == xVertex1 .And. x[ 1 ] == xVertex2 })
	EndIf

	Return nEdge
//-------------------------------------------------------------------
/*/{Protheus.doc} FindAnythingEdge
Verifica se existe alguma Aresta para o Vertice

@param   xVertex, Undefined, Valor correspondente ao Vertice

@return  Numeric, Posição da primeira Aresta de Relacionamento do Vertice
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method FindAnythingEdge( xVertex ) Class GraphEuller
	Return aScan( Self:aEdges , { | x | x[ 1 ] == xVertex .Or. x[ 2 ] == xVertex })
//-------------------------------------------------------------------
/*/{Protheus.doc} RemoveEdge
Remove uma Aresta

@param   nEdge, Numeric, Posição da Aresta no Array de Arestas

@return  Nill, Sempre Nulo
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method RemoveEdge( nEdge ) Class GraphEuller
	aDel( Self:aEdges, nEdge )
	aSize( Self:aEdges, Len( Self:aEdges ) - 1 )
	Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CountEdge
Contador da Quantidade de Arestas de um Vertice

@param   xVertex, Undefined, Valor correspondente ao Vertice

@return  Numeric, Quantidade de Relacionamentos do Vertice
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method CountEdge( xVertex ) Class GraphEuller
	Local nEdge
	Local nCount := 0

	For nEdge := 1 To Len( Self:aEdges )
		If Self:aEdges[ nEdge , 1 ] == xVertex .Or. ;
			Self:aEdges[ nEdge , 2 ] == xVertex
			nCount++
		EndIf
	Next nEdge

	Return nCount
//-------------------------------------------------------------------
/*/{Protheus.doc} IsEulerGraph
Indica se o Grafo é um Grafo Euleriano

@return  Logic, Retorna Verdadeiro caso seja um Grafo Euleriano
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method IsEulerGraph() Class GraphEuller

	Local nNotPar := 0
	Local nVertex
	Local lEuler := .T.

	For nVertex := 1 To Len( Self:aVertex )
		If Self:CountEdge( Self:aVertex[ nVertex ] ) % 2 != 0
			nNotPar++
		EndIf
	Next nVertex

	If nNotPar > 2
		lEuler := .F.
	EndIf

	Return lEuler
//-------------------------------------------------------------------
/*/{Protheus.doc} FirstOddVertex
Determina o Primeiro Valor Ímpar, caso não haja, busca um valor aleatório no Grafo

@return  Undefined, Valor do primeiro Vertice que tenha a quantidade de arestas ímpares
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method FirstOddVertex() Class GraphEuller

	Local xOdd
	Local nVertex
	Local lNotPar := .F.

	For nVertex := 1 To Len( Self:aVertex )
		If Self:CountEdge( Self:aVertex[ nVertex ] ) % 2 != 0
			lNotPar := .T.
			xOdd    := Self:aVertex[ nVertex ]
			Exit
		EndIf
	Next nVertex

	//Caso não tenham nenhum ímpar, pega uma posição aleatória para início
	If !lNotPar
		xOdd := Self:aVertex[ Randomize( 1 , Len( Self:aVertex ) + 1 ) ]
	EndIf

	Return xOdd


//-------------------------------------------------------------------
/*/{Protheus.doc} DFSCount
Busca o caminho máximo que será realizado por um Vertice através de
todas as Arestas ainda disponíveis

@param   xVertFrom, Undefined, Valor do Vertice de Origem

@return  Numeric, Quantidade de Vertices visitados
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method DFSCount( xVertFrom ) Class GraphEuller

	Local nEdge
	Local nCount := 1
	Local xAnotherVertex

	aAdd( Self:aVisited , xVertFrom )

	For nEdge := 1 To Len( Self:aEdges )
		If (    Self:aEdges[ nEdge, 1 ] == xVertFrom .Or. ;
				Self:aEdges[ nEdge, 2 ] == xVertFrom )
			xAnotherVertex := IIf( Self:aEdges[ nEdge, 1 ] == xVertFrom , Self:aEdges[ nEdge, 2 ] , Self:aEdges[ nEdge, 1 ] )
			If aScan( Self:aVisited , { | x | x == xAnotherVertex } ) == 0
				nCount += Self:DFSCount( xAnotherVertex )
			EndIf
		EndIf

	Next nEdge

	Return nCount
//-------------------------------------------------------------------
/*/{Protheus.doc} ValidNextEdge
Valida se a Próxima Aresta é possível de ser utilizada ou se sua utilização
irá comprometer as propriedades do Grafo.
Caso a quantidade de Vertices seja menor após a remoção, indica que a
estrutura será comprometida, torna um Vertice inacessível, com isso,
a Aresta em questão não é válida para utilização

@param   xVertexTo, Undefined, Valor do Vertice de Origem
@param   xVertexFrom, Undefined, Valor do Vertice de Destino

@return  Logic, Indica se a próxima Aresta pode ser utilizada
@type    Method
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method ValidNextEdge( xVertexTo, xVertexFrom ) Class GraphEuller
	Local nCountPrev
	Local nCountAfter
	Local lRet     := .T.

	If Self:CountEdge( xVertexTo ) <> 1
		Self:aVisited := {}
		nCountPrev := Self:DFSCount( xVertexTo )
		Self:RemoveEdge( Self:FindEdge( xVertexTo , xVertexFrom ) )
		Self:aVisited := {}
		nCountAfter := Self:DFSCount( xVertexTo )
		Self:AddEdge( { xVertexTo , xVertexFrom } )
		lRet := If( nCountPrev > nCountAfter, .F., .T. )
	EndIf

	Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} listEuler
Função para chamada recursiva que percorre todas as arestas do Grafo
para determina o caminho a ser precorrido

@param   xVertex, Undefined, Valor do Vertice Incial

@return  Array, Caminho percorrido no Grafo
@type    Method
@return  Nill, Sempre nulo
@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Method listEuler( xVertex ) Class GraphEuller
	Local nEdge
	Local xAnotherVertex
	For nEdge := 1 To Len( Self:aEdges )
		//Percorre todos os Vertices Adjacentes
		If Len(Self:aEdges) >= nEdge .And.;
			(   Self:aEdges[ nEdge, 1 ] == xVertex .Or. ;
				Self:aEdges[ nEdge, 2 ] == xVertex )
			xAnotherVertex := IIf( Self:aEdges[ nEdge, 1 ] == xVertex , Self:aEdges[ nEdge, 2 ] , Self:aEdges[ nEdge, 1 ] )
			If Self:ValidNextEdge( xVertex , xAnotherVertex )
				aAdd( Self:aPath , cValToChar( xVertex ) + " -> " + cValToChar( xAnotherVertex ) )
				Self:RemoveEdge( Self:FindEdge( xVertex , xAnotherVertex ) )
				Self:listEuler( xAnotherVertex )
			EndIf
		EndIf
	Next nVertex

	Return Self:aPath