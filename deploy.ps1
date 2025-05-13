# Logging into GCP
Write-Host "Logging into GCP..."
& gcloud auth activate-service-account --key-file="final-459618-00f6ba605b15.json"

# Set the project
Write-Host "Selecting project..."
& gcloud config set project final-459618

# Initialize SQL tables
Write-Host "🗄Initializing SQL tables..."

cmd.exe /c "mysql --host=34.60.117.175 --user=nodeuser --password=nodepassword nodedb < init.sql"

# Deploy to App Engine
Write-Host "Deploying app.yaml to App Engine..."
& gcloud app deploy app.yaml --quiet

# Done
Write-Host "Deployment complete!"
Write-Host "App URL: https://final-459618.appspot.com"
