using Dapper;
using DapperCourse.Models;
using Microsoft.Data.SqlClient;
using System.Data.SqlClient;
using System.Data.SqlTypes;

namespace DapperCourse.Repositories;

public class VideoGameRepository : IVideoGameRepository
{
    private readonly IConfiguration _configuration;

    public VideoGameRepository(IConfiguration configuration)
    {
        this._configuration = configuration;
    }

    public async Task<List<VideoGame>> GetAllAsync()
    {
        using var connection = GetConnection();
        var videoGame = await connection.QueryAsync<VideoGame>("Select * From VideoGames");

        return videoGame.ToList();
    }

    public async Task<VideoGame> GetByIdAsync(int id)
    {
        using (var connection = GetConnection())
        {
            connection.Open();

            var videoGame = await connection
                                  .QueryFirstOrDefaultAsync<VideoGame>("Select * From VideoGames Where Id = @Id"
                                  , new { Id = id });
            return videoGame!;
        }
    }

    public async Task AddAsync(VideoGame videoGame)
    {
        using var connection = GetConnection();
        connection.Open();
        await connection.ExecuteAsync("Insert Into VideoGames (Title, Publisher, Developer, Platform, ReleaseDate) Values (@Title, @Publisher, @Developer, @Platform, @ReleaseDate)", videoGame);
    }

    public Task DeleteAsync(int id)
    {
        throw new NotImplementedException();
    }

    public Task UpdateAsync(VideoGame videoGame)
    {
        throw new NotImplementedException();
    }

    private SqlConnection GetConnection()
    {
        return new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
    }
}