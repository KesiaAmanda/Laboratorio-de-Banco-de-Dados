package model;

public class Classificacao {
	private Time time;
	private int num_jogos_disputados;
	private int vitorias;
	private int empates;
	private int derrotas;
	private int gols_marcado;
	private int gols_sofridos;
	private int saldo_gols;
	private int pontos;
	
	public Time getTime() {
		return time;
	}
	public void setTime(Time time) {
		this.time = time;
	}
	public int getNum_jogos_disputados() {
		return num_jogos_disputados;
	}
	public void setNum_jogos_disputados(int num_jogos_disputados) {
		this.num_jogos_disputados = num_jogos_disputados;
	}
	public int getVitorias() {
		return vitorias;
	}
	public void setVitorias(int vitorias) {
		this.vitorias = vitorias;
	}
	public int getEmpates() {
		return empates;
	}
	public void setEmpates(int empates) {
		this.empates = empates;
	}
	public int getDerrotas() {
		return derrotas;
	}
	public void setDerrotas(int derrotas) {
		this.derrotas = derrotas;
	}
	public int getGols_marcado() {
		return gols_marcado;
	}
	public void setGols_marcado(int gols_marcado) {
		this.gols_marcado = gols_marcado;
	}
	public int getGols_sofridos() {
		return gols_sofridos;
	}
	public void setGols_sofridos(int gols_sofridos) {
		this.gols_sofridos = gols_sofridos;
	}
	public int getSaldo_gols() {
		return saldo_gols;
	}
	public void setSaldo_gols(int saldo_gols) {
		this.saldo_gols = saldo_gols;
	}
	public int getPontos() {
		return pontos;
	}
	public void setPontos(int pontos) {
		this.pontos = pontos;
	}	
}
