param region string
param rg_name string
param app_name string
param app_plan_name string
param gateway_name string

resource symbolicname 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
            name: 'my-custom-bicep-dashboard'
            location: region
            properties: {
                lenses: [
                    {
                        order: 0
                        parts: [
                        {
                            position: {
                            x: 0
                            y: 0
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/serverFarms/${app_plan_name}'
                                        }
                                        name: 'CpuPercentage'
                                        aggregationType: 4
                                        namespace: 'microsoft.web/serverfarms'
                                        metricVisualization: {
                                            displayName: 'CPU Percentage'
                                            resourceDisplayName: app_plan_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/serverFarms/${app_plan_name}'
                                        }
                                        name: 'CpuPercentage'
                                        aggregationType: 3
                                        namespace: 'microsoft.web/serverfarms'
                                        metricVisualization: {
                                            displayName: 'CPU Percentage'
                                            resourceDisplayName: app_plan_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/serverFarms/${app_plan_name}'
                                        }
                                        name: 'MemoryPercentage'
                                        aggregationType: 4
                                        namespace: 'microsoft.web/serverfarms'
                                        metricVisualization: {
                                            displayName: 'Memory Percentage'
                                            resourceDisplayName: app_plan_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/serverFarms/${app_plan_name}'
                                        }
                                        name: 'MemoryPercentage'
                                        aggregationType: 3
                                        namespace: 'microsoft.web/serverfarms'
                                        metricVisualization: {
                                            displayName: 'Memory Percentage'
                                            resourceDisplayName: app_plan_name
                                        }
                                        }
                                    ]
                                    title: 'App Service Plan resources usage in % (avg max)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 6
                            y: 0
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/serverFarms/${app_plan_name}'
                                        }
                                        name: 'DiskQueueLength'
                                        aggregationType: 4
                                        namespace: 'microsoft.web/serverfarms'
                                        metricVisualization: {
                                            displayName: 'Disk Queue Length'
                                            resourceDisplayName: app_plan_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/serverFarms/${app_plan_name}'
                                        }
                                        name: 'DiskQueueLength'
                                        aggregationType: 3
                                        namespace: 'microsoft.web/serverfarms'
                                        metricVisualization: {
                                            displayName: 'Disk Queue Length'
                                            resourceDisplayName: app_plan_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/serverFarms/${app_plan_name}'
                                        }
                                        name: 'HttpQueueLength'
                                        aggregationType: 4
                                        namespace: 'microsoft.web/serverfarms'
                                        metricVisualization: {
                                            displayName: 'Http Queue Length'
                                            resourceDisplayName: app_plan_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/serverFarms/${app_plan_name}'
                                        }
                                        name: 'HttpQueueLength'
                                        aggregationType: 3
                                        namespace: 'microsoft.web/serverfarms'
                                        metricVisualization: {
                                            displayName: 'Http Queue Length'
                                            resourceDisplayName: app_plan_name
                                        }
                                        }
                                    ]
                                    title: 'App Service Plan queues (avg max)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 0
                            y: 4
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'Requests'
                                        aggregationType: 1
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Requests'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'HttpResponseTime'
                                        aggregationType: 4
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Response Time'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'HttpResponseTime'
                                        aggregationType: 3
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Response Time'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'RequestsInApplicationQueue'
                                        aggregationType: 4
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Requests In Application Queue'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'RequestsInApplicationQueue'
                                        aggregationType: 3
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Requests In Application Queue'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                    ]
                                    title: 'App Service requests'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 6
                            y: 4
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'CpuTime'
                                        aggregationType: 1
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'CPU Time'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                    ]
                                    title: 'App Service CPU time (sum)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 0
                            y: 8
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'Http101'
                                        aggregationType: 1
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Http 101'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'Http2xx'
                                        aggregationType: 1
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Http 2xx'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'Http3xx'
                                        aggregationType: 1
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Http 3xx'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'Http4xx'
                                        aggregationType: 1
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Http 4xx'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'Http5xx'
                                        aggregationType: 1
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Http Server Errors'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                    ]
                                    title: 'App Service http statuses'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 6
                            y: 8
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'MemoryWorkingSet'
                                        aggregationType: 4
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Memory working set'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Web/sites/${app_name}'
                                        }
                                        name: 'MemoryWorkingSet'
                                        aggregationType: 3
                                        namespace: 'microsoft.web/sites'
                                        metricVisualization: {
                                            displayName: 'Memory working set'
                                            resourceDisplayName: app_name
                                        }
                                        }
                                    ]
                                    title: 'App Service memory (avg max)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 0
                            y: 13
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'TotalRequests'
                                        aggregationType: 1
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Total Requests'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'FailedRequests'
                                        aggregationType: 1
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Failed Requests'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                    ]
                                    title: 'App Gateway total and failed requests'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 6
                            y: 13
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'HealthyHostCount'
                                        aggregationType: 4
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Healthy Host Count'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'UnhealthyHostCount'
                                        aggregationType: 4
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Unhealthy Host Count'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                    ]
                                    title: 'App Gateway healthy and unhealthy host count (avg)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 0
                            y: 17
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'Throughput'
                                        aggregationType: 4
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Throughput'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                    ]
                                    title: 'App Gateway throughput (avg)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 6
                            y: 17
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'ApplicationGatewayTotalTime'
                                        aggregationType: 4
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Application Gateway Total Time'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                    ]
                                    title: 'App Gateway total time (avg)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 0
                            y: 21
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'BackendFirstByteResponseTime'
                                        aggregationType: 4
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Backend First Byte Response Time'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'BackendLastByteResponseTime'
                                        aggregationType: 4
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Backend Last Byte Response Time'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                    ]
                                    title: 'App Gateway backend first and last byte response time (avg)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        {
                            position: {
                            x: 6
                            y: 21
                            colSpan: 6
                            rowSpan: 4
                            }
                            metadata: {
                            inputs: [
                                {
                                name: 'options'
                                isOptional: true
                                }
                                {
                                name: 'sharedTimeRange'
                                isOptional: true
                                }
                            ]
                            type: 'Extension/HubsExtension/PartType/MonitorChartPart'
                            settings: {
                                content: {
                                options: {
                                    chart: {
                                    metrics: [
                                        {
                                        resourceMetadata: {
                                            id: '/subscriptions/5a6a5af2-685d-4db2-b571-79307ff2e6e7/resourceGroups/${rg_name}/providers/Microsoft.Network/applicationGateways/${gateway_name}'
                                        }
                                        name: 'BackendConnectTime'
                                        aggregationType: 4
                                        namespace: 'microsoft.network/applicationgateways'
                                        metricVisualization: {
                                            displayName: 'Backend Connect Time'
                                            resourceDisplayName: gateway_name
                                        }
                                        }
                                    ]
                                    title: 'App Gateway backend connect time (avg)'
                                    titleKind: 2
                                    visualization: {
                                        chartType: 2
                                        legendVisualization: {
                                        isVisible: true
                                        position: 2
                                        hideSubtitle: false
                                        }
                                        axisVisualization: {
                                        x: {
                                            isVisible: true
                                            axisType: 2
                                        }
                                        y: {
                                            isVisible: true
                                            axisType: 1
                                        }
                                        }
                                        disablePinning: true
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }]
                        }]
                    metadata: {
                    model: {
                        timeRange: {
                        value: {
                            relative: {
                            duration: 24
                            timeUnit: 1
                            }
                        }
                        type: 'MsPortalFx.Composition.Configuration.ValueTypes.TimeRange'
                        }
                        filterLocale: {
                        value: 'en-us'
                        }
                        filters: {
                        value: {
                            MsPortalFx_TimeRange: {
                            model: {
                                format: 'utc'
                                granularity: 'auto'
                                relative: '24h'
                            }
                            displayCache: {
                                name: 'UTC Time'
                                value: 'Past 24 hours'
                            }
                            filteredPartIds: [
                                'StartboardPart-MonitorChartPart-1ff5b375-544f-4da3-836a-09635be59086'
                                'StartboardPart-MonitorChartPart-1ff5b375-544f-4da3-836a-09635be59099'
                                'StartboardPart-MonitorChartPart-1ff5b375-544f-4da3-836a-09635be590a5'
                                'StartboardPart-MonitorChartPart-1ff5b375-544f-4da3-836a-09635be590b1'
                                'StartboardPart-MonitorChartPart-98fe5046-16c0-47a7-898b-a8fa21dc7070'
                                'StartboardPart-MonitorChartPart-98fe5046-16c0-47a7-898b-a8fa21dc707c'
                                'StartboardPart-MonitorChartPart-98fe5046-16c0-47a7-898b-a8fa21dc7088'
                                'StartboardPart-MonitorChartPart-98fe5046-16c0-47a7-898b-a8fa21dc7094'
                                'StartboardPart-MonitorChartPart-98fe5046-16c0-47a7-898b-a8fa21dc70a0'
                                'StartboardPart-MonitorChartPart-98fe5046-16c0-47a7-898b-a8fa21dc70ac'
                                'StartboardPart-MonitorChartPart-48fcadc3-2d15-48a3-ab24-701cbbbd3503'
                                'StartboardPart-MonitorChartPart-48fcadc3-2d15-48a3-ab24-701cbbbd350f'
                            ]
                            }
                        }
                        }
                    }}
                    }
                }
