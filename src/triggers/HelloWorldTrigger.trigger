/**
 * Created by dkovalchuk on 11-Jul-18.
 */

trigger HelloWorldTrigger on Account (before insert) {
    System.debug('Hello World!');
}