using DapperCourse.Repositories;
using Microsoft.Extensions.Options;
using Scalar.AspNetCore;
using System.Reflection.Metadata;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi(Options =>
{
    Options.AddDocumentTransformer((document, context, _) =>
    {
        document.Info.Title = "Video Games API";
        document.Info.Version = "v1";
        document.Info.Description = "API de videojuegos sin Swagger";
        return Task.CompletedTask;
    });
});

builder.Services.AddScoped<IVideoGameRepository, VideoGameRepository>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

// Mapear Scalar UI
app.MapScalarApiReference();

app.Run();