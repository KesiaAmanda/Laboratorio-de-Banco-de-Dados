package br.edu.fateczl.webServiceExemplo.controller;

import br.edu.fateczl.webServiceExemplo.model.dto.JogadorDTO;
import br.edu.fateczl.webServiceExemplo.model.dto.TimesDTO;
import br.edu.fateczl.webServiceExemplo.model.entity.JogadorTime;
import br.edu.fateczl.webServiceExemplo.repository.JogadorTimeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class JogadorTimeController {
    @Autowired
    private JogadorTimeRepository jogadorTimeRepository;

    @GetMapping("/jogador/idade/{codigo}")
    public ResponseEntity<JogadorDTO> getJogadorIdade(@PathVariable(value = "codigo") int codigo){
        return ResponseEntity.ok().body(converteJogador(jogadorTimeRepository.udfJogadorIdade(codigo)));
    }

    private JogadorDTO converteJogador(JogadorTime j){
        JogadorDTO jDTO = new JogadorDTO();

        jDTO.setAltura(j.getAltura());
        jDTO.setDt_nasc(j.getDt_nasc());
        jDTO.setIdade(j.getIdade());
        jDTO.setNomeJogador(j.getNomeJogador());
        jDTO.setSexo(j.getSexo());

        TimesDTO tDTO = new TimesDTO();
        tDTO.setId(j.getId());
        tDTO.setCidade(j.getCidade());
        tDTO.setNome(j.getCidade());

        jDTO.setTime(tDTO);

        return jDTO;
    }
}
