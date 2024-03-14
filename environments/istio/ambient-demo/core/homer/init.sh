#!/bin/bash

echo "wave description:"
echo "deploying homer portal app"

LB_ADDRESS=$(kubectl get svc -n istio-system --context ${cluster_context} --selector=istio=ingressgateway -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}')

kubectl apply --context ${cluster_context} -f- <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: homer-portal
  labels:
    istio.io/dataplane-mode: ambient
  annotations:
    argocd.argoproj.io/sync-wave: "-5"
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: homer-portal
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: homer-portal
  project: default
  source:
    chart: homer
    repoURL: https://djjudas21.github.io/charts/
    targetRevision: 8.1.9
    helm:
      values: |
        #
        # IMPORTANT NOTE
        #
        # This chart inherits from our common library chart. You can check the default values/options here:
        # https://github.com/k8s-at-home/library-charts/tree/main/charts/stable/common/values.yaml
        #

        controller:
          replicas: 1
        
        image:
          # -- image repository
          repository: ably77/homer
          # -- image tag
          tag: 0.1.0
          # -- image pull policy
          pullPolicy: IfNotPresent
        
        # -- environment variables.
        # @default -- See below
        env:
          # -- Set the container timezone
          TZ: UTC
          # -- Specify the user ID the application will run as
          UID: "1001"
          # -- Specify the group ID the application will run as
          GID: "1001"
          # -- Specify the basepath the application will run at
          SUBFOLDER: /solo
        
        # -- Set labels on the pod
        #podLabels:
        #  istio.io/rev: 1-19
        
        # -- Set annotations on the pod
        podAnnotations:
          proxy.istio.io/config: '{ "holdApplicationUntilProxyStarts": true }'
        
        # -- Configures serviceAccount settings for the chart.
        serviceAccount:
          # -- Specifies whether a service account should be created
          create: true
        
        # -- Configures service settings for the chart.
        # @default -- See values.yaml
        service:
          main:
            enabled: true
            primary: true
            type: ClusterIP
            ports:
              http:
                enabled: true
                port: 8080
                protocol: HTTP
                targetPort: 8080
            labels:
              expose: "true"
        
        ingress:
          # -- Enable and configure ingress settings for the chart under this key.
          # @default -- See values.yaml
          main:
            enabled: false
        
        # -- Configure persistence settings for the chart under this key.
        # @default -- See values.yaml
        persistence:
          config:
            enabled: false
            mountPath: /www/assets
        
        configmap:
          config:
            # -- Store homer configuration as a ConfigMap
            enabled: true
            # -- Homer configuration. See [image documentation](https://github.com/bastienwirtz/homer/blob/main/docs/configuration.md) for more information.
            # @default -- See values.yaml
            data:
              config.yml: |
                #externalConfig: https://raw.githubusercontent.com/bastienwirtz/homer/main/public/assets/config.yml.dist
                ---
                # Homepage configuration
                # See https://fontawesome.com/v5/search for icons options
                
                title: "aoa-catalog demo dashboard"
                subtitle: "Homepage"
                logo: "solo/glooy.png"
                # icon: "fas fa-skull-crossbones" # Optional icon
                
                header: true
                #footer: '<p>Created with <span class="has-text-danger">❤️</span> with <a href="https://bulma.io/">bulma</a>, <a href="https://vuejs.org/">vuejs</a> & <a href="https://fontawesome.com/">font awesome</a> // Fork me on <a href="https://github.com/bastienwirtz/homer"><i class="fab fa-github-alt"></i></a></p>' # set false if you want to hide it.
                footer: false
        
                # Optional theme customization
                theme: default
                colors:
                  light:
                    highlight-primary: "#3367d6"
                    highlight-secondary: "#4285f4"
                    highlight-hover: "#5a95f5"
                    background: "#f5f5f5"
                    card-background: "#ffffff"
                    text: "#363636"
                    text-header: "#ffffff"
                    text-title: "#303030"
                    text-subtitle: "#424242"
                    card-shadow: rgba(0, 0, 0, 0.1)
                    link: "#3273dc"
                    link-hover: "#363636"
                  dark:
                    highlight-primary: "#3367d6"
                    highlight-secondary: "#4285f4"
                    highlight-hover: "#5a95f5"
                    background: "#131313"
                    card-background: "#2b2b2b"
                    text: "#eaeaea"
                    text-header: "#ffffff"
                    text-title: "#fafafa"
                    text-subtitle: "#f5f5f5"
                    card-shadow: rgba(0, 0, 0, 0.4)
                    link: "#3273dc"
                    link-hover: "#ffdd57"
                
                # Optional message
                message:
                  #url: https://b4bz.io
                  style: "is-dark" # See https://bulma.io/documentation/components/message/#colors for styling options.
                  title: "Welcome!"
                  icon: "fa fa-grin"
                  content: "This is a simple navigation homepage for aoa-catalog demo apps running on Istio!<br /> Find more information on <a href='https://github.com/solo-io/aoa-catalog'>github.com/solo-io/aoa-catalog</a><br /><br />More information in the README <a href='https://github.com/solo-io/aoa-catalog/tree/main/environments/gloo-platform/multicluster-onlineboutique/mgmt/#application-description'>here</a>"
                
                # Optional navbar
                # links: [] # Allows for navbar (dark mode, layout, and search) without any links
                links:
                  - name: "Github Repo"
                    icon: "fab fa-github"
                    url: "https://github.com/solo-io/aoa-catalog"
                    target: "_blank" # optional html a tag target attribute
                  - name: "Gloo Mesh Documentation"
                    icon: "fas fa-book"
                    url: "https://docs.solo.io/gloo-mesh-enterprise/latest/"
                  # this will link to a second homer page that will load config from additional-page.yml and keep default config values as in config.yml file
                  # see url field and assets/additional-page.yml.dist used in this example:
                  #- name: "another page!"
                  #  icon: "fas fa-file-alt"
                  #  url: "#additional-page" 
                
                # Services
                # First level array represent a group.
                # Leave only a "items" key if not using group (group name, icon & tagstyle are optional, section separation will not be displayed).
                services:

                  - name: "Admin Applications"
                    icon: "fas fa-cloud"
                    items:
                      - name: "ArgoCD"
                        icon: "fab fa-git-alt"
                        tag: "argo"
                        keywords: "argocd"
                        url: "https://$LB_ADDRESS/argo"
                        target: "_blank" # optional html a tag target attribute
                      - name: "Grafana"
                        icon: "fas fa-chart-area"
                        tag: "grafana"
                        url: "https://$LB_ADDRESS/grafana"
                        target: "_blank" # optional html a tag target attribute
                      - name: "Prometheus"
                        icon: "fas fa-chart-area"
                        tag: "prometheus"
                        url: "https://$LB_ADDRESS/prometheus"
                        target: "_blank" # optional html a tag target attribute
                      - name: "Kiali"
                        icon: "fas fa-chart-area"
                        tag: "kiali"
                        url: "https://$LB_ADDRESS/kiali"
                        target: "_blank" # optional html a tag target attribute
                      - name: "Jaeger"
                        icon: "fas fa-chart-area"
                        tag: "jaeger"
                        url: "https://$LB_ADDRESS/jaeger"
                        target: "_blank" # optional html a tag target attribute
            
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

