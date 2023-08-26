package io.pomatti.app;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

	@GetMapping("/")
	public String ok() {
		return "OK";
	}

	@GetMapping("/hello")
	public String index() {
		return "Hello!";
	}

}
