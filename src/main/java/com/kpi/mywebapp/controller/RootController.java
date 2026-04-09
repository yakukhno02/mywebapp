package com.kpi.mywebapp.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping
public class RootController {

    @GetMapping("/")
    public String root() {
        return "<html><body>"
                + "<h1>MyWebApp</h1>"
                + "<ul>"
                + "<li>GET /items</li>"
                + "<li>POST /items</li>"
                + "<li>GET /items/{id}</li>"
                + "<li>GET /health/alive</li>"
                + "<li>GET /health/ready</li>"
                + "</ul>"
                + "</body></html>";
    }
}
