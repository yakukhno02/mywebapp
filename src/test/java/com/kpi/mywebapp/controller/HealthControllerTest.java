package com.kpi.mywebapp.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.junit.jupiter.api.Assertions.assertThrows;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(HealthController.class)
class HealthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private JdbcTemplate jdbcTemplate;

    @Test
    void aliveShouldReturnOk() throws Exception {
        mockMvc.perform(get("/health/alive"))
                .andExpect(status().isOk())
                .andExpect(content().string("OK"));
    }

    @Test
    void readyShouldReturnOk() throws Exception {
        when(jdbcTemplate.queryForObject("SELECT 1", Integer.class))
                .thenReturn(1);

        mockMvc.perform(get("/health/ready"))
                .andExpect(status().isOk())
                .andExpect(content().string("OK"));
    }

    @Test
    void readyShouldFailWhenDatabaseUnavailable() {
        when(jdbcTemplate.queryForObject("SELECT 1", Integer.class))
                .thenThrow(new RuntimeException());

        assertThrows(Exception.class, () ->
                mockMvc.perform(get("/health/ready"))
        );
    }
}