package io.quarkus.sample;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.validation.constraints.NotBlank;
import java.util.List;

import org.eclipse.microprofile.openapi.annotations.media.Schema;

@Entity
public class Todo extends PanacheEntity {

    @NotBlank
    @Column(unique = true)
    public String title;

    public boolean completed;

    @Column(name = "ordering")
    public int order;

    @Schema(example = "https://github.com/quarkusio/todo-demo-app")
    public String url;

    // TODO: Implement this method to find todos that are not completed
    // Hint: Use Panache's list() method with a filter on the completed field
    public static List<Todo> findNotCompleted() {
        // Replace this with the correct implementation
        return null;
    }

    // TODO: Implement this method to find completed todos
    // Hint: Use Panache's list() method with a filter on the completed field
    public static List<Todo> findCompleted() {
        // Replace this with the correct implementation
        return null;
    }

    // TODO: Implement this method to delete all completed todos
    // Hint: Use Panache's delete() method with a filter on the completed field
    // This should return the number of deleted todos
    public static long deleteCompleted() {
        // Replace this with the correct implementation
        return 0;
    }

}
