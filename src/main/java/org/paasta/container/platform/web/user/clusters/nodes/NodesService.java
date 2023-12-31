package org.paasta.container.platform.web.user.clusters.nodes;

import org.paasta.container.platform.web.user.common.Constants;
import org.paasta.container.platform.web.user.common.RestTemplateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;

/**
 * Nodes Service 클래스
 *
 * @author jjy
 * @version 1.0
 * @since 2020.09.01
 */
@Service
public class NodesService {
    private final RestTemplateService restTemplateService;

    /**
     * Instantiates a new Nodes service
     *
     * @param restTemplateService the rest template service
     */
    @Autowired
    public NodesService(RestTemplateService restTemplateService) {
        this.restTemplateService = restTemplateService;
    }


    /**
     * Nodes 상세 조회(Get Nodes detail)
     *
     * @param cluster  the cluster
     * @param nodeName the nodes name
     * @return the nodes detail
     */
    Nodes getNodes(String cluster, String nodeName) {
        return restTemplateService.send(Constants.TARGET_CP_API, Constants.URI_API_NODES_LIST
                .replace("{cluster:.+}", cluster)
                .replace("{nodeName:.+}", nodeName), HttpMethod.GET, null, Nodes.class);
    }

}
