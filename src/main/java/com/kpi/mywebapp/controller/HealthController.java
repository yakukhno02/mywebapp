package com.kpi.mywebapp.controller;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/health")
public class HealthController {

    private final JdbcTemplate jdbcTemplate;

    public HealthController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/alive")
    public String alive() {
        return "OK";
    }

    @GetMapping("/ready")
    public String ready() {
        try {
            jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            return "OK";
        } catch (Exception e) {
            throw new RuntimeException("Database not ready");
        }
    }
}