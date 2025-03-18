const Ajv = require('ajv');
const addFormats = require('ajv-formats');
const ajv = new Ajv();

// Add all formats from ajv-formats
addFormats(ajv, [
  'date', 'time', 'date-time', 
  'email', 'hostname', 'ipv4', 'ipv6',
  'uri', 'uri-reference', 'uuid',
  'regex'
]);

// Add custom format for regex if needed
ajv.addFormat('regex', {
  validate: (str) => {
    try {
      new RegExp(str);
      return true;
    } catch (e) {
      return false;
    }
  }
});

const fs = require('fs');
const yaml = require('js-yaml');
const glob = require('glob');
const path = require('path');

// Load the schema
const schemaFile = fs.readFileSync('.schemas/openapi3.0_schemas.yaml', 'utf8');
const schema = yaml.load(schemaFile);
const pathSchemaFile = fs.readFileSync('.schemas/openapi3.0_paths.yaml', 'utf8');
const pathSchema = yaml.load(pathSchemaFile);

// Compile the schema
const validate = ajv.compile(schema);
const validatePath = ajv.compile(pathSchema);

// Find all schema files
const schemaFiles = glob.sync('specs/api/**/schemas/*.yaml');
const pathFiles = glob.sync('specs/api/**/paths/*.yaml');

// Validate each file
schemaFiles.forEach(file => {
  try {
    const content = fs.readFileSync(file, 'utf8');
    const data = yaml.load(content);
    
    const valid = validate(data);
    if (valid) {
      console.log(`✅ ${file} is valid`);
    } else {
      console.log(`❌ ${file} has errors:`);
      console.log(validate.errors);
    }
  } catch (err) {
    console.error(`Error processing ${file}:`, err.message);
  }
}); 

pathFiles.forEach(file => {
  try {
    const content = fs.readFileSync(file, 'utf8');
    const data = yaml.load(content);
    
    const valid = validatePath(data);
    if (valid) {
      console.log(`✅ ${file} is valid`);
    } else {
      console.log(`❌ ${file} has errors:`);
      console.log(validate.errors);
    }
  } catch (err) {
    console.error(`Error processing ${file}:`, err.message);
  }
}); 