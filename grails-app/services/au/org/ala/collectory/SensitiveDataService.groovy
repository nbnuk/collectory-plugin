package au.org.ala.collectory

import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonSlurper

@Transactional
class SensitiveDataService {

    def grailsApplication

    /**
     * Return JSON representation of sensitive species held in data provider's datasets
     *
     * @param uid - uid of data provider
     */
    def getSensitiveSpeciesForDataProvider(def uid) {
        if (uid) {
            log.info("sensitive lists = " + grailsApplication.config.sensitive?.speciesLists)
            String sensitiveLists = (grailsApplication.config.sensitive?.speciesLists ?: '').replace(",", "%20OR%20")

            def url = grailsApplication.config.biocacheServicesUrl + "/occurrences/search?q=*:*&fq=data_provider_uid:" + uid + "&fq=species_list_uid:(" + sensitiveLists + ")&facets=names_and_lsid&pageSize=0&facet=on&flimit=-1"
            //&sort=names_and_lsid%20ASC"
            def js = new JsonSlurper()
            def biocacheSearch = js.parse(new URL(url), "UTF-8")
            if (biocacheSearch.totalRecords == 0) {
                return biocacheSearch.facetResults
            }

            List sensitiveSpecies = []
            biocacheSearch.facetResults[0].fieldResult.each { result ->
                def spParts = result.label.split('\\|')
                sensitiveSpecies << [
                        taxon     : spParts[0],
                        lsid      : spParts[1],
                        commonname: spParts[2],
                        records   : result.count
                ]
            }
            return sensitiveSpecies

        } else {
            return null
        }
    }

    /**
     * Return JSON summary of records for a single species held in data provider's datasets
     *
     * @param lsid - uid of species
     * @param uid - uid of data provider
     */
    def getSpeciesRecordsForDataProvider(def lsid, def uid) {
        if (uid && lsid) {
            def url = grailsApplication.config.biocacheServicesUrl + "/occurrences/search?q=*:*&fq=data_provider_uid:" + uid + "&fq=taxon_concept_lsid:" + lsid + "&facets=data_resource_uid&pageSize=0&facet=on&flimit=-1"
            def js = new JsonSlurper()
            def biocacheSearch = js.parse(new URL(url), "UTF-8")
            log.info("biocacheSearch = " + biocacheSearch.toString())
            if (biocacheSearch.totalRecords == 0) {
                return biocacheSearch.facetResults
            }

            List datasetRecords = []
            biocacheSearch.facetResults[0].fieldResult.each { result ->
                def dsParts = result.fq.split(':')
                datasetRecords << [
                        label     : result.label,
                        dr_uid    : dsParts[1],
                        records   : result.count
                ]
            }
            return datasetRecords

        } else {
            return null
        }
    }
}
