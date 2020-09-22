package org.paasta.container.platform.web.user.workloads.deployments;

import org.paasta.container.platform.web.user.common.Constants;
import org.paasta.container.platform.web.user.common.RestTemplateService;
import org.paasta.container.platform.web.user.workloads.pods.Pods;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;

/**
 * Deployments Service 클래스
 *
 * @author jjy
 * @version 1.0
 * @since 2020.09.07
 */
@Service
public class DeploymentsService {

    private final RestTemplateService restTemplateService;

    @Autowired
    public DeploymentsService(RestTemplateService restTemplateService) {
        this.restTemplateService = restTemplateService;
    }


    /**
     * Deployments 목록을 조회한다.
     * @param namespace   the namespace
     * @return the deployments list
     */
    public DeploymentsList getDeploymentsList (String namespace ) {
        return restTemplateService.send( Constants.TARGET_CP_API,
                Constants.URI_API_DEPLOYMENTS_LIST
                        .replace( "{namespace:.+}", namespace ),
                HttpMethod.GET, null, DeploymentsList.class);
    }

    /**
     * Deployments 상세 정보를 조회한다.
     *
     * @param namespace   the namespace
     * @param deploymentName the deployments name
     * @return the deployments
     */
    public Deployments getDeployments (String namespace, String deploymentName ) {
        return restTemplateService.send(Constants.TARGET_CP_API, Constants.URI_API_DEPLOYMENTS_DETAIL
                        .replace( "{namespace:.+}", namespace )
                        .replace( "{deploymentName:.+}", deploymentName )
                , HttpMethod.GET, null, Deployments.class);
    }

    /**
     * Deployments YAML을 조회한다.
     *
     * @param namespace   the namespace
     * @param deploymentName the deployments name
     * @return the deployments yaml
     */
    Deployments getDeploymentsYaml(String namespace, String deploymentName) {
        return restTemplateService.send(Constants.TARGET_CP_API, Constants.URI_API_DEPLOYMENTS_YAML
                        .replace("{namespace:.+}", namespace)
                        .replace("{deploymentName:.+}", deploymentName),
                HttpMethod.GET, null, Deployments.class);
    }

    /**
     * Deployments를 생성한다.
     *
     * @param namespace the namespace
     * @param yaml the yaml
     * @return
     */
    public Object createDeployments(String namespace, String yaml) {
        return restTemplateService.sendYaml(Constants.TARGET_CP_API, Constants.URI_API_DEPLOYMENTS_CREATE
                        .replace("{namespace:.+}", namespace),
                HttpMethod.POST, yaml, Object.class, "application/yaml");
    }

    /**
     * Deployments를 수정한다.
     *
     * @param namespace the namespace
     * @param deploymentName the deployments name
     * @param yaml the yaml
     * @return
     */
    public Object updateDeployments(String namespace, String deploymentName, String yaml) {
        return restTemplateService.sendYaml(Constants.TARGET_CP_API, Constants.URI_API_DEPLOYMENTS_UPDATE
                        .replace("{namespace:.+}", namespace)
                        .replace("{deploymentName:.+}", deploymentName),
                HttpMethod.PUT, yaml, Object.class, "application/yaml");
    }

    /**
     * Deployments를 삭제한다.
     *
     * @param namespace the namespace
     * @param deploymentName the deployments name
     * @return
     */
    public Object deleteDeployments(String namespace, String deploymentName) {
        return restTemplateService.send(Constants.TARGET_CP_API, Constants.URI_API_DEPLOYMENTS_DELETE
                        .replace("{namespace:.+}", namespace)
                        .replace("{deploymentName:.+}", deploymentName),
                HttpMethod.DELETE, null, Object.class);
    }

}
