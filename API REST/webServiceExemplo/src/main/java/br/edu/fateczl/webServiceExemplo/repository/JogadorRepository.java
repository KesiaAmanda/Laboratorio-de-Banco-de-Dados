package br.edu.fateczl.webServiceExemplo.repository;

import br.edu.fateczl.webServiceExemplo.model.entity.Jogador;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface JogadorRepository extends JpaRepository<Jogador, Integer> {
    
	List<Jogador> findJogadoresDataConv();

    Jogador findJogadorDataConv(int codigo);
}
