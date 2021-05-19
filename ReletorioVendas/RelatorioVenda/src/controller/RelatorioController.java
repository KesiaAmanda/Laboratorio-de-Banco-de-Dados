package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.util.JRLoader;
import persistence.GenericDao;

@WebServlet("/Venda")
public class RelatorioController extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	public RelatorioController() {
		super();
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			gerarRelatorio(req, resp);
		} catch (ClassNotFoundException | ServletException | IOException | SQLException | ParseException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	}
	
	private void gerarRelatorio(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, ClassNotFoundException, SQLException, ParseException {
		ServletContext context = getServletContext();
		String erro = "";
		String cpfCliente = req.getParameter("cpfCliente");
	
		SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
		String dataCompra = req.getParameter("dataCompra");		
		Date data = formato.parse(dataCompra);
		formato = new SimpleDateFormat("dd/MM/yyyy");
		dataCompra=formato.format(data);
		
		String logo = "Files/logo.png";
		String relatorio = "WEB-INF/report/RelatorioVendaCliente.jasper";
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("cpf_cliente", cpfCliente);
		param.put("data_venda", dataCompra);
		param.put("logo", context.getRealPath(logo));
		
		byte[] bytes = null;
		
		try {
			JasperReport relatorioVenda = (JasperReport) JRLoader.loadObjectFromFile(context.getRealPath(relatorio));
			bytes = JasperRunManager.runReportToPdf(relatorioVenda, param, new GenericDao().getConnection());
		} catch (JRException e) {
			erro = e.getMessage();
		} finally {
			if (bytes != null) {
				resp.setContentType("application/pdf");
				resp.setContentLength(bytes.length);
				
				ServletOutputStream outputStream = resp.getOutputStream();
				outputStream.write(bytes);
				outputStream.flush();
				outputStream.close();
			}else {
				RequestDispatcher dispatcher = req.getRequestDispatcher("index.jsp");
				req.setAttribute("erro", erro);
				dispatcher.forward(req, resp);
			}
		}
	}
}
