# SearxNG Engine for VedaOS

A production-ready SearxNG search engine service optimized for VedaOS platform integration.

## 🔍 Overview

This repository contains a containerized SearxNG search engine service specifically configured for the VedaOS ecosystem. It provides fast, privacy-focused web search capabilities with multiple search engines and optimized performance settings.

## 🚀 Features

- **Multi-Engine Search**: Google, Bing, DuckDuckGo, Wikipedia, Startpage and more
- **Privacy-Focused**: No tracking, no data collection
- **Production-Ready**: Docker containerization with Redis caching
- **Cloud Deployment**: Ready for Render.com deployment
- **API Integration**: JSON API for seamless VedaOS integration
- **Rate Limiting**: Configurable for production use

## 📋 Prerequisites

- Docker and Docker Compose
- Git

## 🛠️ Quick Start

### Local Development

1. **Clone the repository**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/searxng-engine.git
   cd searxng-engine
   ```

2. **Start the services**:
   ```bash
   ./deploy.sh local
   ```

3. **Test the API**:
   ```bash
   curl "http://localhost:8081/search?q=test&format=json"
   ```

### Production Deployment (Render.com)

1. **Fork/Clone this repository**
2. **Connect to Render.com**
3. **Deploy using the included `render.yaml` configuration**

The service will be automatically deployed with Redis caching and optimized settings.

## 🔧 Configuration

### Environment Variables

- `SEARXNG_BASE_URL`: Base URL for the service (auto-configured in production)
- `SEARXNG_SECRET_KEY`: Secret key for session management

### Search Engines

The service includes these search engines by default:
- Google (Primary)
- Bing
- DuckDuckGo
- Wikipedia
- Startpage
- Google News
- Bing News

## 📡 API Usage

### Search Endpoint

```
GET /search?q={query}&format=json
```

**Parameters:**
- `q`: Search query (required)
- `format`: Response format (`json` for API usage)
- `language`: Language preference (optional, default: auto)
- `engines`: Specific engines to use (optional)

**Example Response:**
```json
{
  "query": "python programming",
  "number_of_results": 10,
  "results": [
    {
      "title": "Python Programming Language",
      "url": "https://python.org",
      "content": "Official Python website..."
    }
  ]
}
```

## 🔒 Security Features

- Rate limiting protection
- CORS configuration
- Secure headers
- No user data retention
- Privacy-focused configuration

## 📊 Performance

- **Response Time**: < 2 seconds average
- **Availability**: 99.9% uptime target
- **Caching**: Redis-based result caching
- **Concurrent Requests**: Optimized for high load

## 🛡️ Privacy

This SearxNG instance:
- Does not log search queries
- Does not track users
- Does not store personal data
- Uses secure communication protocols

## 📁 Project Structure

```
searxng-engine/
├── Dockerfile              # Container configuration
├── docker-compose.yml      # Multi-service setup
├── settings.yml            # SearxNG configuration
├── render.yaml             # Production deployment
├── deploy.sh               # Deployment script
├── .gitignore              # Git ignore rules
└── README.md               # This file
```

## 🔧 Local Development Commands

```bash
# Start services
./deploy.sh local

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild and restart
docker-compose up --build

# Test the API
curl "http://localhost:8081/search?q=python&format=json" | jq '.'
```

## 🚀 Production Deployment

### Render.com Deployment

This repository includes a `render.yaml` file for easy deployment to Render.com:

1. **Create a Render account** at https://render.com
2. **Connect your GitHub repository**
3. **Create a new Web Service** using this repository
4. **Render will automatically**:
   - Use the included `render.yaml` configuration
   - Build the Docker image
   - Deploy with Redis caching
   - Provide a production URL

### Manual Docker Deployment

```bash
# Build the image
docker build -t searxng-engine .

# Run with external Redis
docker run -d \
  --name searxng-engine \
  -p 8080:8080 \
  -e SEARXNG_BASE_URL=https://your-domain.com \
  -e SEARXNG_SECRET_KEY=your-secret-key \
  searxng-engine
```

## ⚡ Performance Optimization

The service is optimized for production with:

- **Redis Caching**: Results cached for improved response times
- **Connection Pooling**: Optimized HTTP connections
- **Request Timeouts**: Configured for fast responses
- **Multiple Engines**: Load balancing across search providers
- **Health Checks**: Automatic service monitoring

## 🔧 Configuration Details

### SearxNG Settings

Key settings in `settings.yml`:
- **Safe Search**: Moderate filtering enabled
- **Request Timeout**: 8 seconds maximum
- **Pool Connections**: 100 concurrent connections
- **Multiple Engines**: 8+ search engines configured

### Docker Configuration

- **Base Image**: Official SearxNG image
- **Redis Integration**: Separate Redis container
- **Volume Mounts**: Configuration mounted as read-only
- **Health Checks**: Both services monitored

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🐛 Troubleshooting

### Common Issues

1. **Port Already in Use**:
   ```bash
   # Change port in docker-compose.yml or stop conflicting service
   sudo lsof -i :8081
   ```

2. **Redis Connection Issues**:
   ```bash
   # Check Redis container status
   docker-compose logs redis
   ```

3. **Search Results Empty**:
   ```bash
   # Check SearxNG logs for engine errors
   docker-compose logs searxng
   ```

### Health Checks

```bash
# Check service health
curl http://localhost:8081/healthz

# Check individual engines
curl "http://localhost:8081/search?q=test&format=json" | jq '.unresponsive_engines'
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [VedaOS Platform](https://github.com/drmrinmoy/vedaOSAgentWeb)
- [SearxNG Project](https://github.com/searxng/searxng)

## 📞 Support

For issues and questions:
- Create an issue in this repository
- Check the [SearxNG documentation](https://docs.searxng.org/)
- Visit [VedaOS Documentation](https://vedaos.com/docs)

---

**Built with ❤️ for the VedaOS ecosystem**

### 🎯 Integration with VedaOS

This SearxNG engine is specifically designed to integrate with the VedaOS platform, providing:

- **Seamless API Integration**: Compatible with VedaOS search interfaces
- **Privacy Compliance**: Meets VedaOS privacy standards
- **Performance Optimization**: Tuned for VedaOS response time requirements
- **Scalable Architecture**: Ready for VedaOS production workloads

For VedaOS-specific integration details, see the main [VedaOS repository](https://github.com/drmrinmoy/vedaOSAgentWeb).