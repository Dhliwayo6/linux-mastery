package com.linuxmastery;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(properties = {
		"spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;MODE=MySQL",
		"spring.datasource.driver-class-name=org.h2.Driver",
		"spring.datasource.username=sa",
		"spring.datasource.password=",
		"spring.jpa.hibernate.ddl-auto=create-drop",
		"spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.H2Dialect",
		"spring.flyway.enabled=false",
		"DB_URL=jdbc:h2:mem:testdb",
		"DB_USERNAME=sa",
		"DB_PASSWORD=",
		"JWT_SECRET=9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc",
		"JWT_REFRESH_SECRET=9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc9a7fb7cc",
		"JWT_ACCESS_EXPIRATION_MS=900000",
		"JWT_REFRESH_EXPIRATION_MS=604800000",
		"REDIS_PASSWORD=dummy",
		"SMTP_USERNAME=dummy",
		"SMTP_PASSWORD=dummy"
})
class BackendApplicationTests {

	@Test
	void contextLoads() {
	}

}
