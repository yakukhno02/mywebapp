package com.kpi.mywebapp.controller;

import com.kpi.mywebapp.dto.ItemResponse;
import com.kpi.mywebapp.service.ItemService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ItemController.class)
class ItemControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private ItemService itemService;

    @Test
    void getAllItemsShouldReturnJson() throws Exception {
        ItemResponse item = new ItemResponse(1L, "Apple", 10, null);

        when(itemService.getAllItems())
                .thenReturn(List.of(item));

        mockMvc.perform(get("/items"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value("Apple"))
                .andExpect(jsonPath("$[0].quantity").value(10));
    }

    @Test
    void getItemByIdShouldReturnJson() throws Exception {
        ItemResponse item = new ItemResponse(1L, "Banana", 5, null);

        when(itemService.getItemById(1L))
                .thenReturn(item);

        mockMvc.perform(get("/items/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Banana"))
                .andExpect(jsonPath("$.quantity").value(5));
    }

    @Test
    void getAllItemsShouldReturnHtml() throws Exception {
        ItemResponse item = new ItemResponse(1L, "Apple", 10, null);

        when(itemService.getAllItems())
                .thenReturn(List.of(item));

        mockMvc.perform(get("/items")
                        .header("Accept", "text/html"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("<html>")));
    }
    @Test
    void getItemByIdShouldReturnHtml() throws Exception {
        ItemResponse item = new ItemResponse(1L, "Banana", 5, null);

        when(itemService.getItemById(1L))
                .thenReturn(item);

        mockMvc.perform(get("/items/1")
                        .header("Accept", "text/html"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("<html>")));
    }
}