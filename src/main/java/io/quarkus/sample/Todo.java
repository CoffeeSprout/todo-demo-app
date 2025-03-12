package io.quarkus.sample;

import jakarta.validation.constraints.NotBlank;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

import org.eclipse.microprofile.openapi.annotations.media.Schema;

public class Todo {

    private static final ConcurrentHashMap<Long, Todo> TODOS = new ConcurrentHashMap<>();
    private static final AtomicLong COUNTER = new AtomicLong(1);

    public Long id;

    @NotBlank
    public String title;

    public boolean completed;

    public int order;

    @Schema(example = "https://github.com/quarkusio/todo-demo-app")
    public String url;

    // In-memory storage methods
    public static List<Todo> listAll(String sortField) {
        List<Todo> todos = new ArrayList<>(TODOS.values());
        // Simple sorting by order
        if ("order".equals(sortField)) {
            todos.sort((a, b) -> Integer.compare(a.order, b.order));
        }
        return todos;
    }

    public static Todo findById(Long id) {
        return TODOS.get(id);
    }

    public static List<Todo> findNotCompleted() {
        return TODOS.values().stream()
                .filter(todo -> !todo.completed)
                .collect(Collectors.toList());
    }

    public static List<Todo> findCompleted() {
        return TODOS.values().stream()
                .filter(todo -> todo.completed)
                .collect(Collectors.toList());
    }

    public static long deleteCompleted() {
        List<Long> completedIds = TODOS.values().stream()
                .filter(todo -> todo.completed)
                .map(todo -> todo.id)
                .collect(Collectors.toList());
        
        completedIds.forEach(TODOS::remove);
        return completedIds.size();
    }

    public void persist() {
        if (this.id == null) {
            this.id = COUNTER.getAndIncrement();
        }
        TODOS.put(this.id, this);
    }

    public void persistAndFlush() {
        persist();
    }

    public void delete() {
        TODOS.remove(this.id);
    }
}