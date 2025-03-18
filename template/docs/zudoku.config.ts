import type { ZudokuConfig } from "zudoku";
import StatusComponent from "./src/Status";

const config: ZudokuConfig = {
  page: {
    logo: {
      src: {
        light: "/logo_black.svg",
        dark: "/logo_white.svg",
      },
    },
  },
  mdx: {
    components: {
      StatusComponent,
    },
  },
  metadata: {
    title: "Corplifting API - %s",
    favicon: "/favicon.svg",
  },
  topNavigation: [
    { id: "docs", label: "Project" },
    { id: "architecture", label: "Architecture" },
    { id: "user_guide", label: "User Guide" },
    { id: "dev_guide", label: "Developer Guide" },
    { id: "changelog", label: "Changelog" },
    { id: "api", label: "API Reference" },
  ],
  sidebar: {
    docs: [
      {
        type: "category",
        label: "Overview",
        items: ["docs/introduction"],
      }
      
    ],
    architecture: [
      {
        type: "category",
        label: "Architectural Overview",
        items: ["architecture/overview/high_level_diagram"
          ,"architecture/overview/core_components"
          ,"architecture/overview/key_design_decisions"
          ,"architecture/overview/compliance_constraints"],
      },
      {
        type: "category",
        label: "Design",
        items: ["architecture/design/detailed_architecture"
          ,"architecture/design/technology_stack"
          ,"architecture/design/security_design"
          ,"architecture/design/data_flows"
          ,"architecture/design/integration_strategies"],
      },
      {
        type: "category",
        label: "Processes",
        items: ["architecture/processes/process_overview"],
      },
      {
        type: "category",
        label: "Infrastructure",
        items: ["architecture/infrastructure/hosting_environments"
          ,"architecture/infrastructure/ci_cd_pipelines"
          ,"architecture/infrastructure/monitoring_and_logging"
          ,"architecture/infrastructure/backup_and_recovery"]
      }  
    ],
    user_guide: [
      {
        type: "category",
        label: "User Guide",
        items: ["user_guide/overview"],
      },
    ],
    dev_guide: [
      {
        type: "category",
        label: "Getting Started",
        items: ["dev_guide/getting_started/setting_up",
          "dev_guide/getting_started/environments",
        ],
      },
      {
        type: "category",
        label: "Developer Practices",
        items: [
          "dev_guide/developer_practices/coding_standards",
          "dev_guide/developer_practices/naming_conventions",
          "dev_guide/developer_practices/branching_strategy",
          "dev_guide/developer_practices/important_classes_and_functions",
        ]
      }
    ],
    changelog: [
      {
        type: "category",
        label: "Changelog",
        items: ["changelog/2501"],
      },
    ],
  },
  redirects: [{ from: "/", to: "/docs/introduction" }],
  apis: {
    type: "file",
    input: "./apis/openapi.yaml",
    navigationId: "api",
  },
  docs: {
    files: "/pages/**/*.{md,mdx}",
  },
};
export default config;