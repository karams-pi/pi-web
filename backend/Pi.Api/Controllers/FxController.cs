using Microsoft.AspNetCore.Mvc;
using Pi.Api.Services;

namespace Pi.Api.Controllers
{
    [ApiController]
    [Route("api/fx")]
    public class FxController : ControllerBase
    {
        private readonly FxService _fx;

        public FxController(FxService fx)
        {
            _fx = fx;
        }

        [HttpGet("usdbrl")]
        public async Task<IActionResult> GetUsdBrl(CancellationToken ct)
        {
            var q = await _fx.GetUsdBrlAsync(ct);
            return Ok(new { rate = q.Rate, source = q.Source, fetchedAt = q.FetchedAt });
        }
    }
}
