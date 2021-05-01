package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Grupo;
import persistence.GrupoDao;
import persistence.TimeDao;

@WebServlet("/Classificacao/Grupos")
public class ServletClassificacaoGrupo extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	public ServletClassificacaoGrupo() {
		super();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		List<Grupo> grupos = new ArrayList<Grupo>();
		List<String> rebaixados = new ArrayList<String>();
		try {
			GrupoDao gDao = new GrupoDao();
			TimeDao tDao = new TimeDao();
			grupos = gDao.selectAll();
			
			for(Grupo g : grupos) {
				g.setTimes(tDao.selectGrupo(g.getGrupo()+""));
			}
			
			rebaixados = tDao.selectRebaixados();
			
		} catch (ClassNotFoundException | SQLException | IOException e) {
			saida = e.getMessage();
		}finally {
			request.setAttribute("grupos", grupos);
			request.setAttribute("rebaixados", rebaixados);
			request.setAttribute("saida", saida);
			request.getRequestDispatcher("Grupos.jsp").forward(request, response);
		}
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
}
