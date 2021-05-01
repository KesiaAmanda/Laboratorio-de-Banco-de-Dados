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

import model.Time;
import persistence.TimeDao;

@WebServlet("/Classificacao/Geral")
public class ServletClassificacaoGeral extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	public ServletClassificacaoGeral() {
		super();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		List<Time> times = new ArrayList<Time>(); 
		List<String> rebaixados = new ArrayList<String>();
		try {
			TimeDao tDao = new TimeDao();
			times = tDao.selectGrupo("");
			
			rebaixados = tDao.selectRebaixados();
			
		} catch (ClassNotFoundException | SQLException | IOException e) {
			saida = e.getMessage();
		}finally {
			request.setAttribute("listaTimes", times);
			request.setAttribute("rebaixados", rebaixados);
			request.setAttribute("saida", saida);
			request.getRequestDispatcher("Geral.jsp").forward(request, response);
		}
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
}
