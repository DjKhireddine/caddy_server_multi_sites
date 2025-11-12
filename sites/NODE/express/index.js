import express from "express";
import { readFile } from "fs/promises";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const app = express();
const PORT = process.env.PORT || 3001;

// Obtenir le chemin du dossier actuel (équivalent à __dirname en ES6)
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

app.use(express.json());

// Fonction pour lire et remplacer les variables dans le template HTML
async function renderHome() {
    try {
        // Lire le fichier HTML
        const htmlPath = join(__dirname, 'views', 'home.html');
        let html = await readFile(htmlPath, 'utf8');

        // Remplacer les variables
        html = html.replace('{{PORT}}', PORT);
        html = html.replace('{{NODE_ENV}}', process.env.NODE_ENV || 'development');

        return html;
    } catch (error) {
        console.error('Erreur lors de la lecture du template:', error);
        return '<h1>Erreur: Template non trouvé</h1>';
    }
}

// Page d'accueil
app.get("/", async (req, res) => {
    const html = await renderHome();
    res.send(html);
});

// Endpoints simples
app.get("/health", (req, res) => {
    res.json({
        status: "ok",
        time: new Date().toISOString(),
        uptime: process.uptime(),
        environment: process.env.NODE_ENV || 'development'
    });
});

app.get("/api/hello", (req, res) => {
    res.json({
        message: "Hello from Node+Express 🚀",
        timestamp: new Date().toISOString(),
        version: "1.0.0"
    });
});

// 404 JSON
app.use((req, res) => {
    res.status(404).json({
        error: "Not found",
        path: req.path,
        method: req.method,
        timestamp: new Date().toISOString()
    });
});

app.listen(PORT, () => {
    console.log(`✅ Node API listening on :${PORT}`);
    console.log(`📍 Accueil: http://localhost:${PORT}`);
    console.log(`🏥 Health: http://localhost:${PORT}/health`);
    console.log(`👋 Hello: http://localhost:${PORT}/api/hello`);
});
