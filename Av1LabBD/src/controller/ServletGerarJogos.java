package controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import persistence.JogosDao;

@WebServlet("/GerarJogos")
public class ServletGerarJogos extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	public ServletGerarJogos() {
		super();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher("gerarJogos.jsp");
		rd.forward(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		try {
			JogosDao jDao = new JogosDao();
			saida = jDao.gerarJogos();
		} catch (ClassNotFoundException | SQLException | IOException e) {
			saida = e.getMessage();
		}finally {
			RequestDispatcher rd = request.getRequestDispatcher("gerarJogos.jsp");
			request.setAttribute("saida", saida);
			rd.forward(request, response);
		}
		
	}
}
