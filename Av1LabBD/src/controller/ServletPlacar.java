package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Jogo;
import persistence.JogoDao;

@WebServlet("/AlterarPlacar")
public class ServletPlacar extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public ServletPlacar() {
        super();
    }
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("alterarPlacar.jsp").forward(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Jogo> jogos = new ArrayList<Jogo>();
		String saida = "";
				
		boolean buscar = request.getParameter("buscar")!=null;
		boolean definirPlacar = request.getParameter("salvarPlacar")!=null;
		
		if(definirPlacar) {
			String codigo[] = request.getParameter("jogoSelect").split(";");
			int golsMandante = Integer.parseInt(request.getParameter("golsMandante"));
			int golsVisitante = Integer.parseInt(request.getParameter("golsVisitante"));
			try {				
				JogoDao jdDao = new JogoDao();
				saida = jdDao.definirPlacar(Integer.parseInt(codigo[0]), golsMandante, Integer.parseInt(codigo[1]), golsVisitante);
			} catch (Exception e) {
				saida = e.getMessage();
			}
		}else if(buscar) {
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			LocalDate dt = LocalDate.parse(request.getParameter("dataJogo"), dtf);
			try {
				JogoDao jDao = new JogoDao();
				jogos.addAll(jDao.selecionarJogos(dt));
			} catch (ClassNotFoundException | SQLException | IOException e) {
				saida = e.getMessage();
			}
		}

		request.setAttribute("saida", saida);
		request.setAttribute("jogos", jogos);
		request.getRequestDispatcher("alterarPlacar.jsp").forward(request, response);
		
	}
	
}
