package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Grupo;
import persistence.GrupoDao;

@WebServlet("/GerarGrupos")
public class ServletGrupos extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ServletGrupos() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Grupo> grupos = null;
		try {
			GrupoDao gDao = new GrupoDao();
			grupos = gDao.selectAll();
		} catch (ClassNotFoundException | SQLException | IOException e) {
			e.printStackTrace();
		} finally {
			RequestDispatcher rd = request.getRequestDispatcher("gerarGrupos.jsp");
			request.setAttribute("grupos", grupos);
			
			rd.forward(request, response);
		}		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saida = "";
		try {
			GrupoDao gDao = new GrupoDao();
			gDao.gerarGrupos();
		} catch (ClassNotFoundException | SQLException | IOException e) {
			saida = e.getMessage();
		} finally {
			request.setAttribute("saida", saida);
			doGet(request, response);
		}	
	}
}
