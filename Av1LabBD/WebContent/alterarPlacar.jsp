<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Alterar Placar</title>
</head>
<body>
	<div align="center">
		<form action="AlterarPlacar" method="post">
		<table>
		<tr>
			<td><input type="hidden" name="acao" id="acao" 
						value=""></td>
		</tr>
		<tr>
			<td><h1>Informe a data do jogo</h1></td>
		</tr>
		<tr>
			<td><input type="date" name="dataJogo" id="dataJogo"
						placeholder="dataJogo"></td>
		</tr>
		<tr>
			<td><input type="submit" name="buscar" id="buscar" 
						value="Buscar">
			</td>
		</tr>
		<tr>
			<th><label for="jogoSelect">Jogo</label></th>
			<td>
				<c:if test="${jogos != null}">
					<select class="form-control" id="jogoSelect" name="jogoSelect">
							<c:forEach var="jogos" items="${jogos}">
								<option value="${jogos.getTimeA().getCodigoTime()};${jogos.getTimeB().getCodigoTime()}">
										${jogos.getTimeA().getNomeTime()} x ${jogos.getTimeB().getNomeTime()}</option>
							</c:forEach>
					</select>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>Gols Mandante</th>
			<th><input type="number" name="golsMandante" id="golsMandante" 
				value="Gols Mandante"></th>
		</tr>
		<tr>
			<th>Gols Visitante</th>
			<td><input type="number" name="golsVisitante" id="golsVisitante" 
				value="Gols Visitante"></td>
		</tr>
		<tr>
			<td><input type="submit" name="salvarPlacar" id="salvarPlacar" 
						value="Salvar Placar">
			</td>
		</tr>
		<c:if test="${not empty dataJogo}">
			<tr><c:out value="${dataJogo}"></c:out></tr>
		</c:if>
		</table>		
		</form>
		
		<form action="AlterarPlacar" method="get">		
		
		<c:if test="${not empty saida}">
					<tr><c:out value="${saida}"></c:out></tr>
				</c:if>
		</form>
		
	</div>
</body>
</html>