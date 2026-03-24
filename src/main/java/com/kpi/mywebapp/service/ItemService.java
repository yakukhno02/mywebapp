package com.kpi.mywebapp.service;

import com.kpi.mywebapp.dto.CreateItemRequest;
import com.kpi.mywebapp.dto.ItemResponse;
import com.kpi.mywebapp.model.Item;
import com.kpi.mywebapp.repository.ItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ItemService {

    private final ItemRepository itemRepository;

    @Autowired
    public ItemService(ItemRepository itemRepository) {
        this.itemRepository = itemRepository;
    }

    @Transactional
    public ItemResponse createItem(CreateItemRequest request) {
        Item item = new Item();
        item.setName(request.getName());
        item.setQuantity(request.getQuantity());

        return toResponse(itemRepository.save(item));
    }

    public ItemResponse getItemById(Long id) {
        Item item = itemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Item not found"));
        return toResponse(item);
    }

    public List<ItemResponse> getAllItems() {
        return itemRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    private ItemResponse toResponse(Item item) {
        return new ItemResponse(
                item.getId(),
                item.getName(),
                item.getQuantity(),
                item.getCreatedAt()
        );
    }
}
