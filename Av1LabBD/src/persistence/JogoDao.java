package persistence;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import model.Jogo;
import model.Time;


public class JogoDao {
	
	private static Connection c;
	
	public JogoDao() throws SQLException, IOException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		c = gDao.getConnection();
	}
	
	public List<Jogo> selecionarJogos(LocalDate dt) throws ClassNotFoundException, SQLException, IOException {
		String sql = "SELECT CodigoTimeA, NomeTimeA, CodigoTimeB, NomeTimeB FROM fn_tabJogos(?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setDate(1, java.sql.Date.valueOf(dt));
		ResultSet rs = ps.executeQuery();
		
		List<Jogo> jogos = new ArrayList<Jogo>();
		
		while (rs.next()) {
			Jogo jogo = new Jogo();
			
			Time time = new Time();
			time.setCodigoTime(rs.getInt(1));
			time.setNomeTime(rs.getString(2));
			jogo.setTimeA(time);
			
			time = new Time();
			time.setCodigoTime(rs.getInt(3));
			time.setNomeTime(rs.getString(4));
			jogo.setTimeB(time);
			
			jogos.add(jogo);
		}
		
		ps.close();
		rs.close();
		return jogos;
	}
	

	
	public String gerarJogos() throws SQLException {
		String sql = "{CALL sp_difinirJogos (?)}";
		CallableStatement cs ;
		
		cs = c.prepareCall(sql);
		cs.registerOutParameter(1, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(1);
		cs.close();
		
		return saida;
	}
	
	public String definirPlacar(int codMandante, int golsMandante, int codVisitante, int golsVisitante) throws SQLException {
		String sql = "{CALL sp_difinePlacar (?,?,?,?,?)}";
		CallableStatement cs ;
		
		cs = c.prepareCall(sql);
		cs.setInt(1, codMandante);
		cs.setInt(2, golsMandante);
		cs.setInt(3, codVisitante);
		cs.setInt(4, golsVisitante);
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		String saida = cs.getString(5);
		cs.close();
		
		return saida;
	}
	
	public Jogo selectQuartasDeFinal(String grupo) throws SQLException {
		String sql = 	"SELECT	nomeTimeA, nomeTimeB " + 
						"FROM fn_tabQuartasDeFinal(?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, grupo);
		ResultSet rs = ps.executeQuery();
		
		Jogo jogo = new Jogo();
		Time time = new Time();
		
		while (rs.next()) {
			time.setNomeTime(rs.getString(1));
			jogo.setTimeA(time);
			time = new Time();
			time.setNomeTime(rs.getString(1));
			jogo.setTimeB(time);
		}
	
		
		ps.close();
		rs.close();
		return jogo;
	}
}
