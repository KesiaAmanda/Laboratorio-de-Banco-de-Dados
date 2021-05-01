package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Jogo;
import persistence.JogoDao;

@WebServlet("/MostrarJogos")
public class ServletJogos extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public ServletJogos() {
		super();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher("mostrarJogos.jsp");
		rd.forward(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Jogo> jogos = new ArrayList<Jogo>();
		String saida = "";
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate dt = LocalDate.parse(request.getParameter("dataJogo"), dtf);
				
		try {
			JogoDao jDao = new JogoDao();
			jogos.addAll(jDao.selecionarJogos(dt));
		} catch (ClassNotFoundException | SQLException | IOException e) {
			saida = e.getMessage();
		}finally {
			RequestDispatcher rd = request.getRequestDispatcher("mostrarJogos.jsp");
			request.setAttribute("saida", saida);
			request.setAttribute("jogos", jogos);
			rd.forward(request, response);
		}
	}
}
