package io.quarkus.sample;

import io.quarkus.sample.audit.AuditType;
import io.quarkus.panache.common.Sort;
import io.vertx.core.eventbus.EventBus;
import jakarta.inject.Inject;

import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.OPTIONS;
import jakarta.ws.rs.PATCH;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Response.Status;
import java.util.List;
import org.eclipse.microprofile.openapi.annotations.Operation;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;

@Path("/api")
@Tag(name = "Todo Resource", description = "All Todo Operations")
public class TodoResource {

    @Inject
    EventBus bus; 
    
    @OPTIONS
    @Operation(hidden = true)
    public Response opt() {
        return Response.ok().build();
    }

    @GET
    @Operation(description = "Get all the todos")
    public List<Todo> getAll() {
        return Todo.listAll(Sort.by("order"));
    }

    @GET
    @Path("/{id}")
    @Operation(description = "Get a specific todo by id")
    public Todo getOne(@PathParam("id") Long id) {
        Todo entity = Todo.findById(id);
        if (entity == null) {
            throw new WebApplicationException("Todo with id of " + id + " does not exist.", Status.NOT_FOUND);
        }
        return entity;
    }

    @POST
    // TODO: Add appropriate annotation for transaction management
    @Operation(description = "Create a new todo")
    public Response create(@Valid Todo item) {
        item.persist();
        bus.publish(AuditType.TODO_ADDED.name(), item);
        return Response.status(Status.CREATED).entity(item).build();
    }

    @PATCH
    @Path("/{id}")
    // TODO: Add appropriate annotation for transaction management
    @Operation(description = "Update an exiting todo")
    public Response update(@Valid Todo todo, @PathParam("id") Long id) {
        Todo entity = Todo.findById(id);
        if(entity.completed!=todo.completed && todo.completed){
            bus.publish(AuditType.TODO_CHECKED.name(), todo);
        }else if(entity.completed!=todo.completed && !todo.completed){
            bus.publish(AuditType.TODO_UNCHECKED.name(), todo);
        }
        
        entity.id = id;
        entity.completed = todo.completed;
        entity.order = todo.order;
        entity.title = todo.title;
        entity.url = todo.url;
        
        // TODO: The entity has been updated but not saved to the database
        // Add the missing code to persist the changes
        // Note: With Panache, entities within a transaction are automatically persisted
        // when the transaction ends, but without @Transactional annotation, you'll need 
        // to explicitly call persist()
        
        return Response.ok(entity).build();
    }

    @DELETE
    // TODO: Add appropriate annotation for transaction management
    @Operation(description = "Remove all completed todos")
    public Response deleteCompleted() {
        Todo.deleteCompleted();
        return Response.noContent().build();
    }

    @DELETE
    @Path("/{id}")
    // TODO: Add appropriate annotation for transaction management
    @Operation(description = "Delete a specific todo")
    public Response deleteOne(@PathParam("id") Long id) {
        Todo entity = Todo.findById(id);
        if (entity == null) {
            throw new WebApplicationException("Todo with id of " + id + " does not exist.", Status.NOT_FOUND);
        }
        entity.delete();
        bus.publish(AuditType.TODO_REMOVED.name(), entity);
        return Response.noContent().build();
    }

    // AI suggestions removed for db branch
    
}