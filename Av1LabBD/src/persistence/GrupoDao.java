package persistence;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Grupo;
import model.Time;

public class GrupoDao {
	
	private Connection c;
	
	public GrupoDao() throws SQLException, IOException, ClassNotFoundException {
		GenericDao gDao = new GenericDao();
		c = gDao.getConnection();
	}
	
	public List<Grupo> selectAll() throws SQLException, ClassNotFoundException, IOException {
		TimeDao tDao = new TimeDao();
		String sql = "SELECT Grupo FROM fn_tabGruposFormados() GROUP BY Grupo";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		List<Grupo> grupos = new ArrayList<Grupo>();
		
		while (rs.next()) {
			Grupo grupo = new Grupo();
			String nomeGrupo = rs.getString("Grupo");
			grupo.setGrupo(nomeGrupo.charAt(0));
			
			List<Time> times = new ArrayList<Time>();
			times.addAll(tDao.selectAll(grupo.getGrupo()));
			grupo.setTimes(times);
			
			grupos.add(grupo);
		}
		
		ps.close();
		rs.close();
		return grupos;
	}
	
	public void gerarGrupos() throws SQLException {
		String sql = "{CALL sp_difineGrupos}";
		CallableStatement cs = c.prepareCall(sql);
		cs.execute();
		cs.close();
	}
}
