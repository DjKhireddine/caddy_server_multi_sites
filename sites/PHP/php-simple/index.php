<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demo PHP - DKDEV</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --secondary: #f59e0b;
            --dark: #1f2937;
            --light: #f8fafc;
            --gray: #6b7280;
            --success: #10b981;
            --error: #ef4444;
        }

        body {
            background: linear-gradient(135deg, #6366f1 0%, #000000 100%);
            color: var(--dark);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            width: 100%;
            margin: 0 auto;
            padding: 2rem;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            margin-bottom: 2rem;
        }

        h1 {
            color: var(--primary);
            text-align: center;
            margin-bottom: 1rem;
            font-size: 2.5rem;
        }

        h2 {
            color: var(--dark);
            margin-bottom: 1rem;
            border-bottom: 2px solid var(--light);
            padding-bottom: 0.5rem;
        }

        h3 {
            color: var(--primary);
            margin: 1.5rem 0 0.5rem 0;
        }

        .info-box {
            background: var(--light);
            padding: 1rem;
            border-radius: 8px;
            margin: 1rem 0;
            border-left: 4px solid var(--primary);
        }

        .server-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin: 1rem 0;
        }

        .info-item {
            background: var(--light);
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
        }

        .info-value {
            font-weight: bold;
            color: var(--primary);
            font-size: 1.1rem;
        }

        .time-display {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--primary-dark);
        }

        form {
            background: var(--light);
            padding: 1.5rem;
            border-radius: 10px;
            margin: 1.5rem 0;
            text-align: center;
        }

        button {
            background: var(--primary);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin: 0.25rem;
        }

        button:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .success {
            background: #d1fae5;
            color: var(--dark);
            padding: 1.5rem;
            border-radius: 8px;
            margin: 1rem 0;
            border-left: 4px solid var(--success);
        }

        .error {
            background: #fee2e2;
            color: var(--error);
            padding: 1rem;
            border-radius: 8px;
            margin: 1rem 0;
            border-left: 4px solid var(--error);
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin: 1.5rem 0;
        }

        .feature {
            background: var(--light);
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
            transition: transform 0.3s;
        }

        .feature:hover {
            transform: translateY(-5px);
        }

        .feature i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }

        .back-link {
            display: inline-block;
            margin-top: 1rem;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            padding: 0.5rem 1rem;
            border: 2px solid var(--primary);
            border-radius: 25px;
            transition: all 0.3s;
        }

        .back-link:hover {
            background: var(--primary);
            color: white;
            text-decoration: none;
        }

        .api-info {
            background: #e0f2fe;
            padding: 1rem;
            border-radius: 8px;
            margin: 1rem 0;
            border-left: 4px solid #0284c7;
            font-size: 0.9rem;
        }

        .quote-content {
            font-size: 1.3rem;
            font-style: italic;
            margin-bottom: 1rem;
            line-height: 1.6;
            text-align: center;
        }

        .quote-author {
            font-weight: bold;
            text-align: center;
            color: var(--primary);
            font-size: 1.1rem;
            margin-bottom: 1rem;
        }

        .quote-tags {
            text-align: center;
            margin-top: 1rem;
        }

        .tag {
            display: inline-block;
            background: var(--primary);
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            margin: 0.2rem;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .quote-source {
            text-align: center;
            margin-top: 1rem;
            font-size: 0.8rem;
            color: var(--gray);
        }

        .btn-programming {
            background: #8b5cf6;
        }

        .btn-programming:hover {
            background: #7c3aed;
        }

        .btn-wisdom {
            background: #10b981;
        }

        .btn-wisdom:hover {
            background: #059669;
        }

        .btn-philosophy {
            background: #f59e0b;
        }

        .btn-philosophy:hover {
            background: #d97706;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h1><i class="fab fa-php"></i> Démonstration PHP</h1>
            <p style="text-align: center; color: var(--gray); margin-bottom: 2rem;">
                Page de démonstration des fonctionnalités PHP - Serveur DKDEV
            </p>

            <!-- Informations du serveur avec heure dynamique -->
            <h2>📊 Informations Serveur</h2>
            <div class="server-info">
                <div class="info-item">
                    <div>Version PHP</div>
                    <div class="info-value"><?php echo phpversion(); ?></div>
                </div>
                <div class="info-item">
                    <div>Logiciel Serveur</div>
                    <div class="info-value"><?php echo $_SERVER['SERVER_SOFTWARE'] ?? 'N/A'; ?></div>
                </div>
                <div class="info-item">
                    <div>Heure Serveur</div>
                    <div class="info-value time-display" id="currentTime">
                        <?php echo date('H:i:s'); ?>
                    </div>
                </div>
                <div class="info-item">
                    <div>Date du Jour</div>
                    <div class="info-value"><?php echo date('d/m/Y'); ?></div>
                </div>
            </div>


            <!-- Variables d'environnement -->
            <h2>🔧 Variables Serveur</h2>
            <div class="info-box">
                <h3>Informations de connexion :</h3>
                <p><strong>Adresse IP :</strong> <?php echo $_SERVER['REMOTE_ADDR'] ?? 'N/A'; ?></p>
                <p><strong>Navigateur :</strong> <?php echo substr($_SERVER['HTTP_USER_AGENT'] ?? 'N/A', 0, 50) . '...'; ?></p>
                <p><strong>Méthode HTTP :</strong> <?php echo $_SERVER['REQUEST_METHOD'] ?? 'N/A'; ?></p>
                <p><strong>Script exécuté :</strong> <?php echo $_SERVER['PHP_SELF'] ?? 'N/A'; ?></p>
            </div>

        </div>
    </div>

    <!-- JavaScript pour l'heure dynamique -->
    <script>
        function updateTime() {
            const now = new Date();
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');
            
            document.getElementById('currentTime').textContent = 
                hours + ':' + minutes + ':' + seconds;
        }

        setInterval(updateTime, 1000);
        updateTime();
    </script>

</body>
</html>
