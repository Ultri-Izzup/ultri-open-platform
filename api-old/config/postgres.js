function loadEnvironmentVariable(keyname) {
    const envVar = process.env[keyname];
    if (!envVar) {
        //throw new Error(`Configuration must include ${keyname}`)
        console.log(`Configuration must include ${keyname}`)
    }
    return envVar;
}

module.exports = {
    postgresUri: loadEnvironmentVariable('POSTGRES_URI'),
}