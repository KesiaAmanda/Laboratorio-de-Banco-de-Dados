package persistence;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
}
