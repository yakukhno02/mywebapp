package com.kpi.mywebapp.controller;

import com.kpi.mywebapp.dto.CreateItemRequest;
import com.kpi.mywebapp.dto.ItemResponse;
import com.kpi.mywebapp.service.ItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/items")
public class ItemController {
    private final ItemService itemService;

    @Autowired
    public ItemController(ItemService itemService) {
        this.itemService = itemService;
    }

    @PostMapping
    public ResponseEntity<ItemResponse> createItem(@RequestBody CreateItemRequest dto) {
        return ResponseEntity.ok(itemService.createItem(dto));
    }

    @GetMapping
    public ResponseEntity<?> getAllItems(
            @RequestHeader(value = "Accept", defaultValue = "application/json") String accept) {

        List<ItemResponse> items = itemService.getAllItems();

        if (accept.contains("text/html")) {
            return ResponseEntity.ok()
                    .header("Content-Type", "text/html")
                    .body(buildItemsHtml(items));
        }

        return ResponseEntity.ok(items);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getItemById(@PathVariable Long id,
            @RequestHeader(value = "Accept", defaultValue = "application/json") String accept) {

        ItemResponse item = itemService.getItemById(id);

        if (accept.contains("text/html")) {
            return ResponseEntity.ok()
                    .header("Content-Type", "text/html")
                    .body(buildItemHtml(item));
        }

        return ResponseEntity.ok(item);
    }

    private String buildItemsHtml(List<ItemResponse> items) {
        StringBuilder html = new StringBuilder();

        html.append("<html><body>");
        html.append("<h1>Items</h1>");
        html.append("<table border='1'>");
        html.append("<tr><th>Name</th><th>Quantity</th></tr>");

        for (ItemResponse item : items) {
            html.append("<tr>")
                    .append("<td>").append(item.getName()).append("</td>")
                    .append("<td>").append(item.getQuantity()).append("</td>")
                    .append("</tr>");
        }

        html.append("</table>");
        html.append("</body></html>");

        return html.toString();
    }

    private String buildItemHtml(ItemResponse item) {
        return "<html><body>" +
                "<h1>Item</h1>" +
                "<p>Name: " + item.getName() + "</p>" +
                "<p>Quantity: " + item.getQuantity() + "</p>" +
                "</body></html>";
    }
}
