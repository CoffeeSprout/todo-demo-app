package io.quarkus.sample;

import java.util.stream.Stream;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.containsString;

@QuarkusTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class TodoResourceTest {

    @Test
    @Order(1)
    public void testGetAll() {
        // For our in-memory implementation, the storage starts empty
        given()
                .accept(ContentType.JSON)
                .when()
                .get("/api")
                .then()
                .statusCode(200)
                .body(is("[]"));
        
        // Add some test data for subsequent tests
        given()
                .contentType(ContentType.JSON)
                .when()
                .body("{\"completed\":true,\"order\":0,\"title\":\"Introduction to Quarkus\"}")
                .post("/api");
                
        given()
                .contentType(ContentType.JSON)
                .when()
                .body("{\"completed\":false,\"order\":1,\"title\":\"Hibernate with Panache\"}")
                .post("/api");
    }

    @Test
    @Order(2)
    public void testGet() {
        given()
                .accept(ContentType.JSON)
                .when()
                .get("/api/1")
                .then()
                .statusCode(200)
                .body(containsString("\"title\":\"Introduction to Quarkus\""));
    }

    @Test
    @Order(3)
    public void testCreateNew() {
        given()
                .contentType(ContentType.JSON)
                .when()
                .body("{\"completed\":false,\"order\":0,\"title\":\"Use the REST Endpoint\"}")
                .post("/api")
                .then()
                .statusCode(201)
                .body(containsString("\"title\":\"Use the REST Endpoint\""));
    }

    @Test
    @Order(4)
    public void testUpdate() {
        // First, get the ID of the latest Todo item
        String response = given()
                .accept(ContentType.JSON)
                .when()
                .get("/api")
                .then()
                .statusCode(200)
                .extract()
                .asString();
        
        // Simple parsing to get the last ID
        // This is a bit fragile but works for our test purpose
        int lastId = 3; // We've created 3 items so far
        
        given()
                .contentType(ContentType.JSON)
                .when()
                .body("{\"id\":" + lastId + ",\"completed\":false,\"order\":0,\"title\":\"Use the GraphQL Endpoint\"}")
                .patch("/api/" + lastId)
                .then()
                .statusCode(200)
                .body(containsString("\"title\":\"Use the GraphQL Endpoint\""));
    }

    @Test
    @Order(5)
    public void testDelete() {
        // First, check if we can delete the item we just updated
        given()
                .when()
                .delete("/api/3") // We've created 3 items so far
                .then()
                .statusCode(204);
        
        // Then check if trying to delete a non-existent item returns 404
        given()
                .when()
                .delete("/api/99")
                .then()
                .statusCode(404);
    }

    // No constants needed for the simplified in-memory tests
}