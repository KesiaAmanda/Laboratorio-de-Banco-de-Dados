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
import model.Jogo;
import persistence.GrupoDao;
import persistence.JogoDao;

@WebServlet("/QuartasDeFinal")
public class ServletQuartasDeFinal extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public ServletQuartasDeFinal() {
		super();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		List<Grupo> grupos = new ArrayList<Grupo>();
		List<Jogo> jogos = new ArrayList<Jogo>();
		try {
			JogoDao jDao = new JogoDao();
			GrupoDao gDao = new GrupoDao();
			grupos = gDao.selectAll();
			
			for(Grupo g : grupos) {
				Jogo jogo = new Jogo();
				jogo = jDao.selectQuartasDeFinal(g.getGrupo()+"");
				jogos.add(jogo);
			}
			
		} catch (ClassNotFoundException | SQLException | IOException e) {
			saida = e.getMessage();
		}finally {
			request.setAttribute("jogos", jogos);
			request.setAttribute("saida", saida);
			request.getRequestDispatcher("QuartasDeFinal.jsp").forward(request, response);
		}
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
}
