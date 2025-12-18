using DapperCourse.Models;
using DapperCourse.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

namespace DapperCourse.Controllers;

[Route("api/[controller]")]
[ApiController]
public class VideoGamesController : ControllerBase
{
    private readonly IVideoGameRepository _videoGameRepository;

    public VideoGamesController(IVideoGameRepository videoGameRepository)
    {
        this._videoGameRepository = videoGameRepository;
    }

    [HttpGet]
    public async Task<ActionResult<List<VideoGame>>> GetAllAsync() => Ok(await _videoGameRepository.GetAllAsync());

    [HttpGet("{id:int}")]
    public async Task<ActionResult<VideoGame>> GetByIdAsync(int id)
    {
        var videoGAme = await _videoGameRepository.GetByIdAsync(id);
        if (videoGAme is null)
        {
            return NotFound($"This video game does not exist!");
        }

        return Ok(videoGAme);
    }

    [HttpPost]
    public async Task<IActionResult> AddAsync(VideoGame videoGame)
    {
        await _videoGameRepository.AddAsync(videoGame);
        return Ok();
    }
}