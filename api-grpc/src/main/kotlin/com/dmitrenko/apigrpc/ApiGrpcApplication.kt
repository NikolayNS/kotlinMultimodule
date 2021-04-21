package com.dmitrenko.apigrpc

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class ApiGrpcApplication

fun main(args: Array<String>) {
    runApplication<ApiGrpcApplication>(*args)
}
