import json
import os
import tarfile
from glob import glob
from landsatxplore.earthexplorer import EarthExplorer
from landsatxplore.api import API
from tqdm import tqdm

import CONFIG


def get_scenes(username, password, dataset_id, start_date, end_date, 
               latitude=1.3521, longitude=103.8198, max_cloud_cover=100, 
               save=False):
    """
    Search for satellite images on EarthExplorer given a search date period. 

    Parameters
    ----------
    username : str
        EarthExplorer username.
    password : str
        EarthExplorer password.
    dataset_id : str
        Satellite dataset ID. Refer to the table. 
    start_date : str
        Search START date in YYYY-MM-DD.
    end_date : str
        Search END date in YYYY-MM-DD.
    latitude : float, optional
        Latitude of the search location. The default is 1.3521.
    longitude : float, optional
        Longtitude of the search location. The default is 103.8198.
    max_cloud_cover : int, optional
        Max cloud cover expressed in percentage. The default is 100.
    save : bool, optional
        If True: save the scenes in a json. The default is False.

    Returns
    -------
    scenes : list
        List of scenes result from EarthExplorer.

    """

    # Initialize a new API instance and get an access key
    api = API(username, password)

    # Search for Landsat TM scenes
    scenes = api.search(
        dataset=dataset_id,
        latitude=latitude,
        longitude=longitude,
        start_date=start_date,
        end_date=end_date,
        max_cloud_cover=max_cloud_cover
    )
    api.logout()
    
    # Save the search results into JSON for use later.
    if save:
        save_name = f'{start_date} - {end_date} Search Results.json'
        save_scenes(scenes, save_name)
    
    scenes.reverse()
    
    return scenes


def save_scenes(scenes, fpath):
    """
    Save the results from the API search into a JSON file.

    Parameters
    ----------
    scenes : list
        The search result from calling API search.
    fpath : str
        The user-defined filename of JSON file.
        
    Returns
    -------
    None.

    """

    # Serializing JSON
    json_output = json.dumps(scenes, indent=4, default=str)

    with open(fpath, 'w') as f:
        f.write(json_output)


def load_scenes(fpath):
    """
    Load the search results JSON file into a list.

    Parameters
    ----------
    fpath : str
        Filepath of the JSON file.

    Returns
    -------
    scenes : list
        List of search results.

    """
    with open(fpath, 'r') as f:
        scenes = json.load(f)

    return scenes


def scenes_summary(scenes, lines=None):
    """
    Print the summary of the search results

    Parameters
    ----------
    scenes : list
        The search result from calling API search.
    lines : int, optional
        The number of scenes to be printed. The default is None.

    Returns
    -------
    None.

    """

    print(f"{len(scenes)} scenes found.\n")

    lines = None if not isinstance(lines, int) else lines
    for i, scene in enumerate(scenes):
        if lines is not None:
            if i >= lines:
                break
        print(f'Dataset {i + 1}')
        print(f'Acquisition Date : {scene["acquisition_date"]}')
        print(f'Scene ID         : {scene["landsat_scene_id"]}')
        print(f'Display ID       : {scene["display_id"]}')
        print(f'Cloud Cover      : {float(scene["cloud_cover"]):.2f} %')
        print('\n')
    
    return None


def infer_year(display_id):
    """
    Infer the acquistion year from scene's display_id'

    Parameters
    ----------
    display_id : str
        Scene display ID.

    Returns
    -------
    str
        Acquisition year.

    """
    
    return display_id.split('_')[3][:4]


def build_save_path(base_dir, dataset_id, display_id): 
    """
    Build the final filepath for the saved file based on the arguments.

    Parameters
    ----------
    base_dir : str
        Base directory.
    dataset_id : str
        Satellite dataset ID. Refer to the table. .
    display_id : str
        Scene's display ID.

    Returns
    -------
    str
        Saved file path.

    """
    
    base_dir = os.path.abspath(base_dir)
    folder_structure = list(CONFIG.DOWNLOAD_LOC[dataset_id].values())
    year = infer_year(display_id)
    output_fpath = os.path.join(base_dir, *folder_structure, year)
    
    return output_fpath  
    
    
def download_scenes(scenes, username, password, base_dir, dataset_id, 
                    check_exist=True, save_undownloaded=False):
    """
    Download the Landsat Dataset from the scenes list.
    
    Parameters
    ----------
    scenes : list or dict
        If list: List of scenes to download. 
        If dict: Single scene to download. 
        Ensure it has all metadata attached and not just the scene_id or product_id.
    username : str
        Username for EarthExplorer account.
    password : str
        Password for the EarthExplorer account.
    base_dir : str
        Base location for the saved file.
    dataset_id : str
        Satellite dataset ID. Refer to the table. 
    check_exist : bool, optional
        Check whether file exist before download. If file exist, skip the download. 
        The default is True. 
    save_undownloaded : bool, optional
        Save a JSON of undownloaded scenes.

    Returns
    -------
    undownload_list : list
        List of scenes that have not been downloaded. 

    """
       
    ee = EarthExplorer(username, password)

    # Check if single scene or list of scenes. 
    if isinstance(scenes, dict):
        display_id = scenes['display_id']
        output_fpath = build_save_path(base_dir, dataset_id, display_id)
        if check_exist:
            _filename = scenes['landsat_product_id']
            if len(glob(os.path.join(output_fpath, _filename) + '.*')) != 0:
                print(f'{display_id} exist. Skipped')
                return None
        scene_id = scenes['landsat_scene_id']
        print(f'Downloading {scene_id} - {display_id}')
        ee.download(scene_id, output_dir=output_fpath, dataset=dataset_id, timeout=20)
        ee.logout()
        print('Download complete.')
        return None

    else:
        _num = len(scenes)
        _skipped = 0
        undownload_list = scenes.copy()
        
        for _i, scene in enumerate(scenes):
            display_id = scene['display_id']
            output_fpath = build_save_path(base_dir, dataset_id, display_id)
            if check_exist:
                _filename = scene['landsat_product_id']
                if len(glob(os.path.join(output_fpath, _filename) + '.*')) != 0:
                    _skipped += 1
                    continue
            scene_id = scene['landsat_scene_id']
            

            print(f'Downloading {_i + 1}/{_num} - {scene_id} - {display_id} (Skipped {_skipped})')
            ee.download(scene_id, output_dir=output_fpath, dataset=dataset_id, timeout=20)

            del undownload_list[0]

        if save_undownloaded:
            save_scenes(undownload_list, 'Undownloaded Scenes.json')

        ee.logout()
        print('Download complete')
        return undownload_list

    
# download(self, identifier, output_dir, dataset=None, timeout=300, skip=False):
def split_scenes(scenes):
    """
    Split the scenes results into Level 1, Level 2 and orphan datasets based
    on display_id. This may not be accurate. 
    The reason for this functions is because even thought Level 1 data product
    is requested for EarthExplorer, Level 2 product is also produced. This
    could be a naming error on EE side. The best way to check is to untar the 
    data set and look for B11 amd B12. 

    Parameters
    ----------
    scenes : list
        List of scenes to download. Ensure it has all metadata attached and not
        just the scene_id or product_id..

    Returns
    -------
    level_1_datasets : list
        List of Level 1 scenes based on name. 
    level_2_datasets : list
        List of Level 2 scenes based on name.
    orphan_datasets : list
        List of orphan scenes that does not match the naming convention.

    """

    level_1_datasets = []
    level_2_datasets = []
    orphan_datasets = []

    for scene in scenes:
        level = scene['landsat_product_id'].split('_')[-1]
        if level == 'T1':
            level_1_datasets.append(scene)
        elif level == 'T2':
            level_2_datasets.append(scene)
        else:
            orphan_datasets.append(scene)

    return level_1_datasets, level_2_datasets, orphan_datasets


def untar_scenes(fpath, check_exist=True, pbar=True):
    """
    Untar all the downloaded scenes in a folder. 

    Parameters
    ----------
    fpath : str
        File path of the folder where scenes are saved.
    check_exist : bool ,optional
        Check whether folder exist before untar. If folder exist, skip the untar. 
        The default is True.
    pbar : bool, optional
        Check whether to display progress bar when untar.
        The default is True.      

    Returns
    -------
    None.

    """

    fnames = []

    for file in os.listdir(fpath):
        if file.endswith(('tar', 'gz')):
            fnames.append(os.path.join(fpath, file))

    # Based on the file extension, get the appropriate read mode.
    for fname in fnames:
        if fname.endswith("tar.gz"):
            read_mode = 'r:gz'
        elif fname.endswith("tar"):
            read_mode = 'r:'
        else:
            continue

        foldername = os.path.basename(fname).split('.')[0]
    
        if check_exist:
            if os.path.exists(os.path.join(fpath, foldername)):
                print(f'Skipped untar {foldername}')
                continue
        with tarfile.open(fname, read_mode) as tar:
            if pbar:                
                for member in tqdm(iterable=tar.getmembers(), 
                                   desc=f'Extracting {foldername}'):
                    tar.extract(member=member, path=fname.split('.')[-3])
            else:
                print(f'Extracting {foldername}')
                if read_mode =='r:gz':
                    tar.extractall(fname.split('.')[-3])
                elif read_mode =='r:':
                    tar.extractall(fname.split('.')[-2])
                
