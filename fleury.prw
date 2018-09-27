#define CRLF CHR(10) + CHR(13)
//-------------------------------------------------------------------
/*/{Protheus.doc} Fleury
Calculo do Caminho Euleriano com base no Algoritmo de Fleury

@author  Jackson Machado
@since   27/09/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Main Function Fleury()

	Local nPath
	Local cMsg    := ""
	Local aPath   := {}

	/*
		Tests:
		Ciclo Euleriano
		Local aVertex := { 'u' , 'y' , 'x' , 'w' , 'v' }
		Local aEdges  := { ;
							{ 'u' , 'y' } , ;
							{ 'u' , 'v' } , ;
							{ 'y' , 'v' } , ;
							{ 'y' , 'v' } , ;
							{ 'y' , 'x' } , ;
							{ 'x' , 'w' } , ;
							{ 'w' , 'v' } ;
							}

		Ciclo não Euleriano
		Local aVertex := { 'u' , 'y' , 'x' , 'w' }
		Local aEdges  := { ;
							{ 'u' , 'y' } , ;
							{ 'u' , 'x' } , ;
							{ 'y' , 'x' } , ;
							{ 'x' , 'w' } ;
							}

		Grafo sem Ciclo
		Local aVertex := { 'u' , 'y' , 'x' , 'w' }
		Local aEdges  := { ;
							{ 'u' , 'y' } , ;
							{ 'u' , 'x' } , ;
							{ 'u' , 'w' } ;
							}
	*/
	Local aVertex := { 'u' , 'y' , 'x' , 'w' , 'v' }
	Local aEdges  := { ;
						{ 'u' , 'y' } , ;
						{ 'u' , 'v' } , ;
						{ 'y' , 'v' } , ;
						{ 'y' , 'v' } , ;
						{ 'y' , 'x' } , ;
						{ 'x' , 'w' } , ;
						{ 'w' , 'v' } ;
						}
	Local oGraph := GraphEuller():New( aVertex , aEdges )

	//Verifica se todos os Vertices possuem arestas pares
	If oGraph:IsEulerGraph()
		aPath := oGraph:listEuler( oGraph:FirstOddVertex() )
		If SubStr( aPath[1] , 1 , 1 ) <> SubStr( aPath[Len(aPath)] , Len(aPath[Len(aPath)] ) )
			cMsg := "Não é um ciclo Euleriano pois não encerrou no mesmo Vertice." + CRLF
		Else
			cMsg := "É um ciclo Euleriano pois encerrou no mesmo Vertice." + CRLF
		EndIf
		For nPath := 1 To Len( aPath )
			cMsg += aPath[ nPath ] + CRLF
		Next nPath
		MsgInfo( cMsg , "AVISO")
	Else
		MsgInfo( "Somente é possível calcular o ciclo Euleriano se o Grafo possuir apenas 2 ou nenhum vertece(s) com números ímpares de arestas." , "AVISO" )
	EndIf

	Return