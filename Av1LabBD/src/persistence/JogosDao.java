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

import model.Jogos;
import model.Time;


public class JogosDao {
	
	private static Connection c;
	
	public JogosDao() throws SQLException, IOException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		c = gDao.getConnection();
	}
	
	public List<Jogos> selecionarJogos(LocalDate dt) throws ClassNotFoundException, SQLException, IOException {
		String sql = "SELECT NomeTimeA, NomeTimeB FROM fn_tabJogos(?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setDate(1, java.sql.Date.valueOf(dt));
		ResultSet rs = ps.executeQuery();
		
		List<Jogos> jogos = new ArrayList<Jogos>();
		
		while (rs.next()) {
			Jogos jogo = new Jogos();
			
			Time time = new Time();
			time.setNomeTime(rs.getString(1));
			jogo.setTimeA(time);
			
			time = new Time();
			time.setNomeTime(rs.getString(2));
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
	
}
