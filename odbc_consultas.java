package teste_connector;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class example {
	public static void main(String[] args) {
		try {
			Connection conexao = null;
			PreparedStatement comando = null;
			ResultSet resultado = null;
			
			String con = "jdbc:mysql://localhost:3306/PROJETO1";
	        String user = "root";
	        String password = "senha";
	        		
		    conexao = DriverManager.getConnection(con, user, password);
		   
		    if (!conexao.isClosed() ) {
		    	System.out.println(" 							CONECTED TO DATABASE! ");
		    }
		    else {
		    	System.out.println(" 							ERROR CONNECTING TO DATABASE! ");
		    }
		    
		    String consulta;
		    
		    /* Consulta 1 */
		    consulta = "SELECT  NOME_COMPLETO,"
		    		+ "        TITULO_DA_DISSERTACAO_TESE "
		    		+ "FROM    DOCENTE D"
		    		+ "       INNER JOIN DOUTORADO T"
		    		+ "        ON    D.DOCENTE_ID = T.DOCENTE_ID "
		    		+ "WHERE   T.NOME_INSTITUICAO = ? AND D.SEXO = ?;";
		    
		    comando = conexao.prepareStatement(consulta);
		    
		    comando.setString(1,"Universidade Estadual de Campinas");
		    comando.setString(2,"H");
		    
		    if (comando.execute()); {
		    	resultado = comando.getResultSet(); 
		    	System.out.println("\n*************************************************************************************************************************************************");
		    	System.out.println("CONSULTA 1: Procura docentes e suas respectivas teses de doutorado cuja tese foi defendida na UNICAMP e o sexo do docente é masculino");
		    	System.out.println("*************************************************************************************************************************************************\n");
		    	while (resultado.next()) {
				   System.out.println("Nome: " + resultado.getString("NOME_COMPLETO") );
				   System.out.println("Titulo da Tese: " + resultado.getString("TITULO_DA_DISSERTACAO_TESE") );
				   System.out.println();
				}
		    }	
		    
		    comando.clearParameters();
		    
		    /* Consulta 2 */
		    consulta = "SELECT  NOME_COMPLETO,"
		    		+ "        TITULO AS LINHA_DE_PESQUISA,"
		    		+ "        T.NUM_PREMIOS AS NUM_PREMIOS "
		    		+ "FROM    DOCENTE D"
		    		+ "        INNER JOIN LINHA_DE_PESQUISA L"
		    		+ "        ON    D.DOCENTE_ID = L.DOCENTE_ID"
		    		+ "        INNER JOIN ("
		    		+ "                    SELECT COUNT(PREMIO_TITULO_ID) AS NUM_PREMIOS,"
		    		+ "									E.DOCENTE_ID"
		    		+ "                    FROM   DOCENTE E"
		    		+ "                           INNER JOIN PREMIO_TITULO P"
		    		+ "                           ON    E.DOCENTE_ID = P.DOCENTE_ID"
		    		+ "					GROUP BY P.DOCENTE_ID"
		    		+ "                    ) T"
		    		+ "        ON     D.DOCENTE_ID = T.DOCENTE_ID "
		    		+ "WHERE   T.NUM_PREMIOS > ? "
		    		+ "ORDER BY T.NUM_PREMIOS;";
		    
		    comando = conexao.prepareStatement(consulta);
		    
		    comando.setInt(1,10);
		    
		    if (comando.execute()); {
		    	resultado = comando.getResultSet(); 
		    	System.out.println("*************************************************************************************************************************************************");
		    	System.out.println("CONSULTA 2: Procura docentes, suas respectivas linhas de pesquisa e o numero de prêmios/titulos que tenham adquirido mais de 10 premios/titulos,\nordenados pelo total de premios/titulos.");
		    	System.out.println("*************************************************************************************************************************************************\n");
		    	while (resultado.next()) {		    		
		    		System.out.println("Nome: " + resultado.getString("NOME_COMPLETO") );
					System.out.println("Linha de Pesquisa: " + resultado.getString("LINHA_DE_PESQUISA") );
					System.out.println("Numero de Premios: " + resultado.getInt("NUM_PREMIOS") );
					System.out.println();
				}
		    }	
		    
		    comando.clearParameters();
		    
		    /* Consulta 3 */
		    consulta = "SELECT  NOME_COMPLETO,"
		    		+ "        T.NOME_INSTITUICAO AS NOME_INSTITUICAO "
		    		+ "FROM    DOCENTE D"
		    		+ "        INNER JOIN DOUTORADO T"
		    		+ "        ON    D.DOCENTE_ID = T.DOCENTE_ID"
		    		+ "        INNER JOIN MESTRADO M"
		    		+ "        ON    D.DOCENTE_ID = M.DOCENTE_ID"
		    		+ "        INNER JOIN GRADUACAO G"
		    		+ "        ON    D.DOCENTE_ID = G.DOCENTE_ID "
		    		+ "WHERE   T.NOME_INSTITUICAO = M.NOME_INSTITUICAO AND T.NOME_INSTITUICAO = G.NOME_INSTITUICAO "
		    		+ "ORDER BY NOME_COMPLETO;";
		    
		    comando = conexao.prepareStatement(consulta);
		   
		    if (comando.execute()); {
		    	resultado = comando.getResultSet();
		    	System.out.println("*************************************************************************************************************************************************");
		    	System.out.println("CONSULTA 3: Procura docentes que fizeram Graduação, Mestrado e Doutorado na mesma instituição");
		    	System.out.println("*************************************************************************************************************************************************\n");
		    	while (resultado.next()) {
				   System.out.println("Nome: " + resultado.getString("NOME_COMPLETO") );
				   System.out.println("Nome Instituicao: " + resultado.getString("NOME_INSTITUICAO") );
				   System.out.println();
				}
		    }	
		    
		    comando.clearParameters();
		    
		    /* Consulta 4 */
		    consulta = "SELECT  T.NOME AS NOME_PROJETO, "
		    		+ "			D.NOME_COMPLETO AS RESPONSAVEL_PROJETO,"
		    		+ "         T.NOME_COMPLETO AS NOME_INTEGRANTE,"
		    		+ " 		T.ANO_INICIO AS ANO_INICIO "
		    		+ "	FROM    DOCENTE D"
		    		+ "        INNER JOIN ("
		    		+ "                    SELECT  NOME,"
		    		+ "                            NOME_COMPLETO,"
		    		+ "                            DOCENTE_ID AS ID,"
		    		+ "                            ANO_INICIO"
		    		+ "                    FROM    PROJETO_DE_PESQUISA P"
		    		+ "                            INNER JOIN INTEGRANTE_DO_PROJETO I"
		    		+ "                            ON P.PROJETO_ID = I.PROJETO_ID"
		    		+ "					WHERE P.SITUACAO = ? "
		    		+ "                    ORDER BY NOME_COMPLETO"
		    		+ "                    ) T"
		    		+ "        ON          D.DOCENTE_ID = T.ID "
		    		+ "WHERE SEXO = ? AND T.ANO_INICIO > ? "
		    		+ "ORDER BY T.ANO_INICIO;";
		    
		    comando = conexao.prepareStatement(consulta);
		    
		    comando.setString(1, "EM_ANDAMENTO");
		    comando.setString(2, "M");
		    comando.setInt(3, 2012);
		    
		    if (comando.execute()); {
		    	resultado = comando.getResultSet();
		    	System.out.println("*************************************************************************************************************************************************");
		    	System.out.println("CONSULTA 4: Lista os projetos (e seus integrantes) que ainda estao em andamento, sao coordenados por mulheres e se iniciaram depois de 2012 em \nordem crescente de ano de inicio.");
		    	System.out.println("*************************************************************************************************************************************************\n");
		    	while (resultado.next()) {		    		
		    		System.out.println("Nome do Projeto: " + resultado.getString("NOME_PROJETO") );
		    		System.out.println("Ano de Inicio: " + resultado.getInt("ANO_INICIO") );
					System.out.println("Responsavel pelo Projeto: " + resultado.getString("RESPONSAVEL_PROJETO") );
					System.out.println("Nome do Integrante: " + resultado.getString("NOME_INTEGRANTE") );
					System.out.println();
				} 	
		    }	
		    
		    comando.clearParameters();
		    
		    /* Consulta 5 */
		    consulta = "SELECT  NOME_COMPLETO,"
		    		+ "        T.NUM_ARTIGOS AS NUM_ARTIGOS,"
		    		+ "        Q.NUM_ORIENTACAO AS NUM_ORIENTACOES,"
		    		+ "        P.NUM_BANCA AS NUM_BANCAS_PARTICIPADAS "
		    		+ "FROM    DOCENTE D"
		    		+ "        INNER JOIN ("
		    		+ "                    SELECT  COUNT(ARTIGO_ID) AS NUM_ARTIGOS,"
		    		+ "                            E.DOCENTE_ID"
		    		+ "                    FROM    DOCENTE E"
		    		+ "                            INNER JOIN ARTIGO A"
		    		+ "                            ON    E.DOCENTE_ID = A.DOCENTE_ID"
		    		+ "                    GROUP BY E.DOCENTE_ID"
		    		+ "                    ) T"
		    		+ "        ON          D.DOCENTE_ID = T.DOCENTE_ID"
		    		+ "        INNER JOIN ("
		    		+ "                    SELECT  COUNT(BANCA_ID) AS NUM_BANCA,"
		    		+ "                            F.DOCENTE_ID"
		    		+ "                    FROM    DOCENTE F"
		    		+ "                            INNER JOIN BANCA B"
		    		+ "                            ON    F.DOCENTE_ID = B.DOCENTE_ID"
		    		+ "                    GROUP BY B.DOCENTE_ID"
		    		+ "                    ) P"
		    		+ "        ON          D.DOCENTE_ID = P.DOCENTE_ID"
		    		+ "        INNER JOIN ("
		    		+ "                    SELECT  COUNT(ORIENTACAO_ID) AS NUM_ORIENTACAO,"
		    		+ "                            G.DOCENTE_ID"
		    		+ "                    FROM    DOCENTE G"
		    		+ "                            INNER JOIN ORIENTACAO O"
		    		+ "                            ON    G.DOCENTE_ID = O.DOCENTE_ID"
		    		+ "                    GROUP BY O.DOCENTE_ID"
		    		+ "                ) Q"
		    		+ "        ON          D.DOCENTE_ID = Q.DOCENTE_ID "
		    		+ "WHERE   P.NUM_BANCA > Q.NUM_ORIENTACAO "
		    		+ "ORDER BY T.NUM_ARTIGOS;";
		    
		    comando = conexao.prepareStatement(consulta);
		    
		    if (comando.execute()); {
		    	resultado = comando.getResultSet(); 
		    	System.out.println("*************************************************************************************************************************************************");
		    	System.out.println("CONSULTA 5: Procura docentes e o respectivo numero de artigos publicados cujo numero de participações em bancas seja maior que o numero de \norientações realizadas.");
		    	System.out.println("*************************************************************************************************************************************************\n");
		    	while (resultado.next()) {
				   System.out.println("Nome: " + resultado.getString("NOME_COMPLETO") );
				   System.out.println("Numero de Artigos: " + resultado.getInt("NUM_ARTIGOS") );
				   System.out.println("Numero de Orientacoes: " + resultado.getInt("NUM_ORIENTACOES") );
				   System.out.println("Numero de Bancas Participadas: " + resultado.getInt("NUM_BANCAS_PARTICIPADAS") );
				   System.out.println("");
				}
		    	System.out.println("*************************************************************************************************************************************************\n");
		    }	
		    
		    comando.clearParameters();
		    
		    if(resultado != null) {
		    	resultado.close();
		    }
		    if(comando != null) {
		    	comando.close();
		    }
		    if(conexao != null) {
		    	conexao.close();
		    }
		} catch (SQLException ex) {

		    System.out.println("SQLException: " + ex.getMessage());
		    System.out.println("SQLState: " + ex.getSQLState());
		    System.out.println("VendorError: " + ex.getErrorCode());
		}
	}
}
