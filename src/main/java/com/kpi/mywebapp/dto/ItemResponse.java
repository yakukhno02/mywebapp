package com.kpi.mywebapp.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
public class ItemResponse {
    private Long id;
    private String name;
    private Integer quantity;
    private LocalDateTime createdAt;
}
