package persistence;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Classificacao;
import model.Time;

public class TimeDao {
	private Connection c;
	
	public TimeDao() throws SQLException, IOException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		c = gDao.getConnection();
	}
	
	public List<Time> selectAll(char grupo) throws SQLException {
		String sql = "SELECT NomeTime FROM fn_tabGruposFormados() WHERE Grupo = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, grupo+"");
		ResultSet rs = ps.executeQuery();
		
		List<Time> times = new ArrayList<Time>();
		
		while (rs.next()) {
			Time time = new Time();
			time.setNomeTime(rs.getString("NomeTime"));
			times.add(time);
		}
		
		ps.close();
		rs.close();
		return times;
	}
	
	public List<Time> selectGrupo(String grupo) throws SQLException {
		String sql = 	"SELECT	nome_time, num_jogos_disputados, vitorias, empates, derrotas, " + 
						"gols_marcados, gols_sofridos, saldo_gols, pontos " + 
						"FROM fn_tabClassficacao(?)  " + 
						"ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, grupo);
		ResultSet rs = ps.executeQuery();
		
		List<Time> times = new ArrayList<Time>();
		
		while (rs.next()) {
			Time time = new Time();
			time.setNomeTime(rs.getString(1));
			
			Classificacao et = new Classificacao();
			et.setTime(time);
			et.setNum_jogos_disputados(rs.getInt(2));
			et.setVitorias(rs.getInt(3));
			et.setEmpates(rs.getInt(4));
			et.setDerrotas(rs.getInt(5));
			et.setGols_marcado(rs.getInt(6));
			et.setGols_sofridos(rs.getInt(7));
			et.setSaldo_gols(rs.getInt(8));
			et.setPontos(rs.getInt(9));
			
			time.setClassificacao(et);
			times.add(time);
		}
		
		ps.close();
		rs.close();
		return times;
	}
	
	public List<String> selectRebaixados() throws SQLException {
		String sql = 	"SELECT nome_time " + 
						"FROM fn_tabRebaixados()";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		List<String> times = new ArrayList<String>();
		
		while (rs.next()) {
			String time = rs.getString(1);			
			times.add(time);
		}
		
		ps.close();
		rs.close();
		return times;
	}
}
